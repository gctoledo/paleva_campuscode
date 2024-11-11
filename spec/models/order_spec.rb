require 'rails_helper'

RSpec.describe Order, type: :model do
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
  end

  describe '#valid?' do
    it 'false when customer name is empty' do
      order = @restaurant.orders.new(customer_email: 'john@doe.com')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.valid?

      expect(result).to eq false
    end

    it 'false when customer email AND customer phone is empty' do
      order = @restaurant.orders.new(customer_name: 'John Doe')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.valid?

      expect(result).to eq false
    end

    it 'true when customer email is filled but customer phone doesnt' do
      order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.valid?

      expect(result).to eq true
    end

    it 'true when customer phone is filled but customer email doesnt' do
      order = @restaurant.orders.new(customer_name: 'John Doe', customer_phone: '11111111111')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.valid?

      expect(result).to eq true
    end

    it 'false when customer phone is invalid' do
      order = @restaurant.orders.new(customer_name: 'John Doe', customer_phone: '11111111111111')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.valid?

      expect(result).to eq false
    end

    it 'false when customer email is invalid' do
      order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.valid?

      expect(result).to eq false
    end

    it 'false when have no order items' do
      order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      result = order.valid?

      expect(result).to eq false
    end

    it 'generate unique alphanumeric code' do
      order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.code.present?

      expect(result).to eq true
    end

    it 'with success' do
      order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      order.add_order_item(dish: @dish, portion: @dish.portions.first)
      result = order.valid?

      expect(result).to eq true
    end
  end
end
