require 'rails_helper'

describe 'User visits homepage' do

  ##! CRIAR UM ARQUIVO USER_ACCESS_SPEC.RB NA PASTA AUTH E TESTAR ACESSO DO USUARIO NAS PAGINAS RESTRITAS A USUARIOS LOGADOS

  it 'and is kicked out because he is not authenticated' do
    #Arrange
    
    #Act
    visit root_path

    #Assert
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(page).to have_content('Não possui conta? Cadastre-se agora!')
  end

  it 'and is redirected because not have a restaurant registered' do
    #Arrange
    
    #Act
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    visit root_path

    #Assert
    expect(current_path).to eq new_restaurants_path
    expect(page).to have_content('Você precisa cadastrar seu restaurante antes de continuar.')
  end

  it 'and logout' do
    #Arrange
    
    #Act
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    visit root_path
    click_on 'Sair'

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'with success' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    
    #Act
    visit root_path

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content(user.first_name)
  end
end