require 'rails_helper'

describe 'User visits order details page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    dish = create_dish(restaurant: @r)
    @order = @r.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
    @order.add_order_item(dish: dish, portion: dish.portions.first)
    @order.save
  end

  it 'and is kicked out because order is from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    visit order_path(@order.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and sees details of order' do 
    visit orders_path
    click_on 'Visualizar'

    expect(page).to have_content('John Doe')
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Prato')
    expect(page).to have_content('Aguardando confirmação')
    expect(page).to have_content('R$ 25,00')
  end
end