require 'rails_helper'

describe 'User tries to delete dish' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    r = create_restaurant(user)
    create_opentime(user)
    @dish = r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    @dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @dish.save
  end

  it 'but cant delete dishes from another restaurant' do
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    create_opentime(second_user)

    login_as(second_user)
    delete(dish_path(@dish.id))

    expect(response).to redirect_to root_path
    expect(response).not_to be_successful
  end
end