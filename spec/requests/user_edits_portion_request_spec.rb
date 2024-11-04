require 'rails_helper'

describe 'User try edits a portion' do
  it 'and cant edit portions from other restaurants' do
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
    portion = drink.portions.new(description: 'Lata', price: 5)
    drink.save

    #Act
    patch(drink_portion_path(drink.id, portion.id), params: { portion: { price: 6 } })

    #Assert
    expect(response).to redirect_to root_path
  end
end