require 'rails_helper'

describe 'User try edits a drink' do

  it 'and cant edit drinks from other restaurants' do
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
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
    login_as(second_user)
    patch(drink_path(drink.id), params: { drink: { name: 'Guaraná' } })
    drink.reload

    #Assert
    expect(response).to redirect_to root_path
    expect(drink.name).to eq 'Coca-cola'
  end

  it 'but cant edit drink status from other restaurant' do
    #Arrange
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
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
    login_as(second_user)
    patch(disable_drink_path(drink.id))
    drink.reload

    #Assert
    expect(response).to redirect_to root_path
    expect(drink.active).to eq true
  end
end