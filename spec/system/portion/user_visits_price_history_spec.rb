require 'rails_helper'

describe 'User visits price history page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    @dish = @r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    @dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @p = @dish.portions.new(description: 'Grande', price: 25)
    @dish.save
  end

  it 'and is authenticated' do
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'
    click_on 'Grande'
    
    expect(current_path).to eq price_history_dish_portion_path(@dish.id, @p.id)
  end

  it 'and is not authenticated' do
    logout()

    visit price_history_dish_portion_path(@dish.id, @p.id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'after create a new portion' do
    visit price_history_dish_portion_path(@dish.id, @p.id)

    expect(page).to have_content 'Não houve alteração de preço dessa porção!'
  end

  it 'after update a portion price' do
    visit edit_dish_portion_path(@dish.id, @p.id)
    fill_in 'Preço', with: 30
    click_on 'Salvar porção'
    click_on 'Grande'

    expect(current_path).to eq price_history_dish_portion_path(@dish.id, @p.id)
    expect(page).to have_content 'R$ 25,00'
    expect(page).to have_content @p.price_histories.last.changed_at.strftime("%d/%m/%Y")
  end

  it 'and cant access price histories from other restaurants' do
    #Arrange
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    #Act
    visit price_history_dish_portion_path(@dish.id, @p.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end
end