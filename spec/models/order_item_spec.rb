require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  before(:each) do
    @restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
    User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @restaurant.id)

    @dish = @restaurant.dishes.new(name: 'Parmegiana', description: 'É muito bom!')
    @dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @dish.portions.new(description: 'Prato', price: 25)

    @order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
  end

  describe '#valid?' do
    it 'false when price is empty' do
      order_item = OrderItem.new(order: @order, portion: @dish.portions.first)
      result = order_item.valid?

      expect(result).to eq false
    end

    it 'with success' do
      order_item = OrderItem.new(order: @order, portion: @dish.portions.first, price: @dish.portions.first.price)
      result = order_item.valid?

      expect(result).to eq true
    end
  end
end
