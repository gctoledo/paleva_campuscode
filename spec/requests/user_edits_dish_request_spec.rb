require 'rails_helper'

describe 'User try edits a dish' do
  it 'and cant edit dishes from other restaurants' do
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    create_restaurant(first_user)
    create_opentime(first_user)
    create_opentime(second_user)
    dish = first_user.restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save

    #Act
    login_as(second_user)
    patch(dish_path(dish.id), params: { dish: { name: 'Macarronada' } })
    dish.reload

    #Assert
    expect(response).to redirect_to root_path
    expect(response).not_to be_successful
    expect(dish.name).to eq 'Parmegiana'
  end

  it 'but cant edit dishes status from other restaurant' do
    #Arrange
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    create_restaurant(first_user)
    create_opentime(first_user)
    create_opentime(second_user)
    dish = first_user.restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save

    #Act
    login_as(second_user)
    patch(disable_dish_path(dish.id))
    dish.reload

    #Assert
    expect(response).to redirect_to root_path
    expect(response).not_to be_successful
    expect(dish.active).to eq true
  end
end