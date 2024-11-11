require 'rails_helper'

RSpec.describe Portion, type: :model do
  describe '#valid?' do
    it 'false when description is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )

      #Act
      portion = dish.portions.new(price: 25)
      result = portion.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when price is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      
      #Act
      portion = dish.portions.new(description: 'Grande')
      result = portion.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when price have two more decimals' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      
      #Act
      portion = dish.portions.new(description: 'Grande', price: 5.5757575)
      result = portion.valid?

      #Assert
      expect(result).to eq false
    end

    it 'with success' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      
      #Act
      portion = dish.portions.new(description: 'Grande', price: 25)
      result = portion.valid?

      #Assert
      expect(result).to eq true
    end
  end
end
