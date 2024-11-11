require 'rails_helper'

RSpec.describe PreRegisteredUser, type: :model do
  describe '#valid?' do
    it 'false when email is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      user = PreRegisteredUser.new(cpf: CPF.generate, restaurant: restaurant)

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when email is invalid' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      user = PreRegisteredUser.new(cpf: CPF.generate, email: 'invalid_email', restaurant: restaurant)

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when CPF is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      user = PreRegisteredUser.new(email: 'john@doe.com', restaurant: restaurant)

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when CPF is invalid' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      user = PreRegisteredUser.new(email: 'john@doe', cpf: 'invalid_cpf', restaurant: restaurant)

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'with success' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      user = PreRegisteredUser.new(email: 'john@doe.com', cpf: CPF.generate, restaurant: restaurant)

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq true
    end
  end
end
