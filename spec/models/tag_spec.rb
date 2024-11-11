require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid?' do
    it 'false when name is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      tag = restaurant.tags.new()
      result = tag.valid?

      #Assert
      expect(result).to eq false
    end

    it 'name is formatted when tag is created' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      tag = restaurant.tags.new(name: 'veGetAriAno')
      result = tag.valid?

      #Assert
      expect(tag.name).to eq 'Vegetariano'
      expect(result).to eq true
    end

    it 'success' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      tag = restaurant.tags.new(name: 'Vegetariano')
      result = tag.valid?

      #Assert
      expect(result).to eq true
    end
  end
end
