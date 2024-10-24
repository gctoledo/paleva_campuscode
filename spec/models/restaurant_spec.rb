require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#valid?' do
    it 'false when trade_name is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when legal_name is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when cnpj is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when address is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, phone: '11111111111', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when phone is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when email is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when email is already in use' do
      #Arrange
      first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      first_restaurant = Restaurant.create!(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: first_user)
      second_user = User.new(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: first_restaurant.email, user: second_user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when cnpj is already in use' do
      #Arrange
      first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      first_restaurant = Restaurant.create!(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: first_user)
      second_user = User.new(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')

      #Act
      restaurant = Restaurant.new(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: first_restaurant.cnpj, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when legal_name is already in use' do
      #Arrange
      first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      first_restaurant = Restaurant.create!(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: first_user)

      second_user = User.new(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')

      #Act
      restaurant = Restaurant.new(trade_name: 'McDonalds', legal_name: first_restaurant.legal_name, cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when phone is smaller then 10 numbers' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '123456789', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when phone is bigger then 11 numbers' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '123456789012', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when email is not valid' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'invalid_email', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when cnpj is not valid' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: 'invalid_cnpj', address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq false
    end

    it 'creates unique random code' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      code = restaurant.code

      #Assert
      expect(code).to be_present
      expect(code.length).to eq(6)
    end

    it 'with success' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      
      #Act
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      result = restaurant.valid?

      #Assert
      expect(result).to eq true
    end
  end
end
