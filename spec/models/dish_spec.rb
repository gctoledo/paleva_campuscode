require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe '#valid?' do
    it 'false when name is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: restaurant.id)
      
      #Act
      dish = restaurant.dishes.new(description: 'É bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      result = dish.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when description is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: restaurant.id)
      
      #Act
      dish = restaurant.dishes.new(name: 'Parmegiana')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      result = dish.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when image is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: restaurant.id)
      
      #Act
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É muito bom!')
      result = dish.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when image format is invalid' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: restaurant.id)
      
      #Act
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É muito bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_file.txt'),
        filename: 'test_file.txt',
        content_type: 'text/plain'
      )
      result = dish.valid?

      #Assert
      expect(result).to eq false
    end

    it 'creates dish with active status being true' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: restaurant.id)
      
      #Act
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É muito bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      result = dish.valid?

      #Assert
      expect(dish.active).to eq true
      expect(result).to eq true
    end

    it 'success' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: restaurant.id)
      
      #Act
      dish = restaurant.dishes.new(name: 'Parmegiana', description: 'É muito bom!')
      dish.image.attach(
        io: File.open('spec/fixtures/test_image.png'),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      result = dish.valid?

      #Assert
      expect(result).to eq true
    end
  end
end
