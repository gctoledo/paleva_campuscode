require 'rails_helper'

RSpec.describe Opentime, type: :model do
  describe '#valid?' do
    it 'false when week_day is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      opentime = restaurant.opentimes.new(open: '08:30', close: '18:00')
      result = opentime.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when open is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      opentime = restaurant.opentimes.new(week_day: 0, close: '18:00')
      result = opentime.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when close is empty' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      opentime = restaurant.opentimes.new(week_day: 0, open: '08:30')
      result = opentime.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when close time is less than open time' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      opentime = restaurant.opentimes.new(week_day: 0, open: '18:00', close: '08:30')
      result = opentime.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when week day already exists' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      restaurant.opentimes.new(week_day: 0, open: '18:00', close: '08:30')
      
      #Act
      opentime = restaurant.opentimes.new(week_day: 0, open: '18:00', close: '08:30')
      result = opentime.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when week day is different than 0..6' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      opentime = restaurant.opentimes.new(week_day: 10, open: '18:00', close: '08:30')
      result = opentime.valid?

      #Assert
      expect(result).to eq false
    end

    it 'with success' do
      #Arrange
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      #Act
      opentime = restaurant.opentimes.new(week_day: 0, open: '08:30', close: '18:00')
      result = opentime.valid?

      #Assert
      expect(result).to eq true
    end
  end
end
