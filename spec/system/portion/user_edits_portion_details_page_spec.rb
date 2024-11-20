require 'rails_helper'

describe 'User visits portion edition page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    @drink = user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    @drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @portion = @drink.portions.new(description: 'Lata', price: 5)
    @drink.save
  end

  it 'and is authenticated' do
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Coca-cola'
    within('table') do
      click_on 'Editar'
    end

    expect(current_path).to eq edit_drink_portion_path(@drink.id, @portion.id)
  end

  it 'and is not authenticated' do
    logout()

    visit edit_drink_portion_path(@drink.id, @portion.id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end


  it 'and cant visit edit portion page from other restaurants' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    #Act
    visit edit_drink_portion_path(@drink.id, @portion.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso não autorizado'
  end

  it 'and edits a portion' do
    #Act
    visit edit_drink_portion_path(@drink.id, @portion.id)
    within('#portion-form') do
      fill_in 'Preço', with: '6'
    end
    click_on 'Salvar porção'

    #Assert
    expect(current_path).to eq drink_path(@drink.id)
    expect(page).to have_content('Lata')
    expect(page).to have_content('R$ 6,00')
  end
end