require 'rails_helper'

describe 'User visits dish creation page' do
  it 'and sees all form inputs in creation form' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)

    #Act
    visit root_path
    click_on 'Pratos'
    click_on 'Cadastrar'

    #Assert
    expect(current_path).to eq new_dish_path
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Calorias')
    expect(page).to have_field('Imagem')
  end

  it 'and cant create dish with incorrect params' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)

    #Act
    visit new_dish_path
    click_on 'Salvar prato'

    #Assert
    expect(page).to have_selector('form#create-dish-form')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
  end

  it 'and creates a dish' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)

    #Act
    visit new_dish_path
    within('#create-dish-form') do
      fill_in 'Nome', with: 'Parmegiana'
      fill_in 'Descrição', with: 'É um prato italiano feito com berinjela frita e fatiada, coberta com queijo e molho de tomate e depois assada.'
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    end
    click_on 'Salvar prato'

    #Assert
    expect(current_path).to eq dishes_path
    expect(page).to have_content('Prato cadastrado com sucesso!')
  end
end