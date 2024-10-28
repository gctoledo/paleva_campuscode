require 'rails_helper'

describe 'User visits drinks pages' do
  it 'and cant access drinks from other restaurants' do
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
    drink.save

    #Act
    visit drink_path(drink.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end

  it 'and can access your drinks' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    drink = user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save

    #Act
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Coca-cola'

    #Assert
    expect(current_path).to eq drink_path(drink.id)
    expect(page).to have_content('Coca-cola')
  end
end