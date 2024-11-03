require 'rails_helper'

describe 'User visits price history page' do
  it 'after create a new portion' do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    dish = user.restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.portions.new(description: 'Grande', price: 25)
    dish.save

    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'
    click_on 'Grande'

    expect(page).to have_content 'Não houve alteração de preço dessa porção!'
  end

  it 'after update a portion price' do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    dish = user.restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    p = dish.portions.new(description: 'Grande', price: 25)
    dish.save

    visit edit_dish_portion_path(dish.id, p.id)
    fill_in 'Preço', with: 30
    click_on 'Salvar porção'
    click_on 'Grande'

    expect(current_path).to eq price_history_dish_portion_path(dish.id, p.id)
    expect(page).to have_content 'R$ 25,00'
    expect(page).to have_content p.price_histories.last.changed_at.strftime("%d/%m/%Y")
  end

  it 'and cant access price histories from other restaurants' do
    #Arrange
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    login_as(second_user)
    create_restaurant(first_user)
    create_opentime(first_user)
    create_opentime(second_user)
    drink = first_user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    p = drink.portions.new(description: 'Lata', price: 5)
    drink.save

    #Act
    visit price_history_drink_portion_path(drink.id, p.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end
end