require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it 'false when first_name is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, last_name: 'Doe', password: 'password123456')

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end
    
    it 'false when last_name is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', password: 'password123456')

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when email is empty' do
      #Arrange
      user = User.new(cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when password is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe')

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when CPF is empty' do
      #Arrange
      user = User.new(email: 'john@doe.com', first_name: 'John', last_name: 'Doe', password: 'password123456')

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end

    it 'false when CPF is invalid' do
      #Arrange
      user = User.new(email: 'john@doe.com', first_name: 'John', last_name: 'Doe', password: 'password123456', cpf: 'invalid_cpf')

      #Act
      result = user.valid?

      #Assert
      expect(result).to eq false
    end
  end
end
