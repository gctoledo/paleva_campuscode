require 'rails_helper'

describe 'User visits orders page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'and have no orders registered' do
    visit orders_path

    expect(page).to have_content('Nenhum pedido encontrado.')
  end

  it 'and sees all orders' do 
    dish = create_dish(restaurant: @r)
    order = @r.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
    order.add_order_item(dish: dish, portion: dish.portions.first)
    order.save
    
    visit orders_path

    expect(page).to have_content('John Doe')
    expect(page).to have_content('john@doe.com')
    expect(page).to have_content('Aguardando confirmação')
  end
end