require 'rails_helper'

describe 'User visits public orders page' do

  it 'with authenticated user' do
    r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: r.id)
    login_as(user)

    visit track_orders_path

    expect(page).to have_field('Código do Pedido')
  end

  it 'with no authenticated user' do
    visit track_orders_path

    expect(page).to have_field('Código do Pedido')
  end

  it 'and searchs with invalid code' do
    visit track_orders_path
    within('#search-order-form') do
      fill_in 'Código do Pedido', with: 'invalid_code'
    end
    click_on 'Buscar Pedido'

    expect(current_path).to eq track_orders_path
    expect(page).to have_content('Pedido não encontrado')
  end

  it 'and searchs with valid code' do
    r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: r.id)
    login_as(user)
    create_opentime(r)
    dish = create_dish(restaurant: r)
    order = r.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
    order.add_order_item(dish: dish, portion: dish.portions.first)
    order.save

    visit track_orders_path
    within('#search-order-form') do
      fill_in 'Código do Pedido', with: order.code
    end
    click_on 'Buscar Pedido'

    expect(current_path).to eq track_order_path(order.code)
  end
end