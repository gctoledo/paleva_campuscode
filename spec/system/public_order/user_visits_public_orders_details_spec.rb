require 'rails_helper'

describe 'User visits public order details page' do
  before(:each) do
    r = create_restaurant()
    @user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: r.id)
    create_opentime(r)
    dish = create_dish(restaurant: r)
    @order = r.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
    @order.add_order_item(dish: dish, portion: dish.portions.first)
    @order.save
  end

  it 'as authenticated user' do
    login_as(@user)

    visit track_order_path(@order.code)

    expect(page).to have_content('Detalhes do Pedido')
  end

  it 'as no authenticated user' do
    visit track_order_path(@order.code)

    expect(page).to have_content('Detalhes do Pedido')
  end

  it 'and sees all order information' do
    visit track_order_path(@order.code)

    expect(page).to have_content("Restaurante: #{@order.restaurant.trade_name}")
    expect(page).to have_content("Endereço do restaurante: #{@order.restaurant.address}")
    expect(page).to have_content("Contato do restaurante: #{@order.restaurant.phone} | #{@order.restaurant.email}")
    expect(page).to have_content("Valor do pedido: R$ #{@order.total_price.to_i},00")
    expect(page).to have_content(@order.order_items[0].dish.name)
    expect(page).to have_content('Criado')
  end
end