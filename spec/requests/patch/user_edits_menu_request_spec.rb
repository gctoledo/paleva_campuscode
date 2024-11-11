require 'rails_helper'

describe 'User try edits a menu' do
  before(:each) do
    r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: r.id)
    login_as(user)
    create_opentime(r)
    @menu = r.menus.create!(name: 'Almoço')
  end

  it 'and cant edit menus from other restaurants' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)

    login_as(second_user)
    patch(menu_path(@menu.id), params: { menu: { name: 'Jantar' } })

    expect(response).to redirect_to root_path
    expect(response).not_to be_successful
  end
end