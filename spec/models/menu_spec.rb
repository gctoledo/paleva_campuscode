require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#valid?' do
    it 'false when name is empty' do
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      
      menu = restaurant.menus.new()
      result = menu.valid?

      expect(result).to eq false
    end

    it 'with success' do
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
      restaurant = Restaurant.new(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', user: user)
      
      menu = restaurant.menus.new(name: 'Almoço')
      result = menu.valid?

      expect(result).to eq true
    end
  end
end
