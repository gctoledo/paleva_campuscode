require 'rails_helper'

describe 'User visits restaurant creation page' do 
  it 'and sees form inputs' do 
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)

    #Act
    visit root_path

    #Assert
    expect(page).to have_field('Nome fantasia')
    expect(page).to have_field('Razão social')
    expect(page).to have_field('E-mail')
    expect(page).to have_field('CNPJ')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Telefone')
  end

  it 'and is redirected because already has a restaurant' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)

    #Act
    visit new_restaurants_path

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Você já possui um restaurante cadastrado!')
  end

  it 'and tries to create a restaurant with incorrect params' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)

    #Act
    visit root_path
    click_on 'Criar restaurante'
    
    #Assert
    expect(page).to have_content('Nome fantasia não pode ficar em branco')
    expect(page).to have_content('Razão social não pode ficar em branco')
    expect(page).to have_content('CNPJ não pode ficar em branco')
    expect(page).to have_content('CNPJ não é válido')
    expect(page).to have_content('Endereço não pode ficar em branco')
    expect(page).to have_content('Telefone não pode ficar em branco')
    expect(page).to have_content('Telefone deve ter 10 ou 11 dígitos')
    expect(page).to have_content('E-mail não pode ficar em branco')
    expect(page).to have_content('E-mail não é válido')
    expect(page).to have_content('Erro ao cadastrar restaurante')
  end

  it 'and creates a restaurant' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)

    #Act
    visit root_path
    within('#create-restaurant-form') do
      fill_in 'Nome fantasia', with: 'McDonalds'
      fill_in 'Razão social', with: 'McDonalds'
      fill_in 'E-mail', with: 'mc@donalds.com'
      fill_in 'CNPJ', with: CNPJ.generate
      fill_in 'Endereço', with: 'Rua Ruby, 28 - Vila do Rails'
      fill_in 'Telefone', with: '11111111111'
    end
    click_on 'Criar restaurante'
    
    #Assert
    expect(page).to have_content('Restaurante cadastrado com sucesso!')
    expect(current_path).to eq root_path
  end
end