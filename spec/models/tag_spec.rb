require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid?' do
    it 'false when name is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      
      #Act
      tag = restaurant.tags.new()
      result = tag.valid?

      #Assert
      expect(result).to eq false
    end

    it 'name is formatted when tag is created' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      
      #Act
      tag = restaurant.tags.new(name: 'veGetAriAno')
      result = tag.valid?

      #Assert
      expect(tag.name).to eq 'Vegetariano'
      expect(result).to eq true
    end

    it 'success' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      
      #Act
      tag = restaurant.tags.new(name: 'Vegetariano')
      result = tag.valid?

      #Assert
      expect(result).to eq true
    end
  end
end
