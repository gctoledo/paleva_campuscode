require 'rails_helper'

describe 'User visits drink edition page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    @drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    @drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @drink.save
  end

  it 'and sees all form inputs' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Coca-cola'
    click_on 'Editar'

    #Assert
    expect(current_path).to eq(edit_drink_path(@drink.id))
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Alcoólica?')
    expect(page).to have_field('Imagem')
  end

  it 'and cant visit edit drink page from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)
    

    #Act
    visit edit_drink_path(@drink.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso não autorizado'
  end

  it 'and can edit drink' do
    #Act
    visit edit_drink_path(@drink.id)
    within('#drink-form') do
    fill_in 'Nome', with: 'Pepsi'
    fill_in 'Descrição', with: 'Outro refrigerante de cola'
    attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    click_on 'Salvar bebida'
  end

    #Assert
    expect(current_path).to eq(drink_path(@drink.id))
    expect(page).to have_content('Bebida atualizada com sucesso')
  end
end