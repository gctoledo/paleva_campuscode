require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do
    it 'false when name is empty' do
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      menu = restaurant.menus.new()
      result = menu.valid?

      expect(result).to eq false
    end

    it 'with success' do
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com')
      
      menu = restaurant.menus.new(name: 'Almoço')
      result = menu.valid?

      expect(result).to eq true
    end
  end
end
