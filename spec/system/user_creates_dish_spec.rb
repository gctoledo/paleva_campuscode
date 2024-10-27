require 'rails_helper'

describe 'User visits dish page' do
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

  it 'and cant access dishes from other restaurants' do
    #Arrange
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    login_as(second_user)
    create_restaurant(first_user)
    create_opentime(first_user)
    create_opentime(second_user)
    dish = first_user.restaurant.dishes.create!(name: 'Parmegiana', description: 'É bom!')

    #Act
    visit dish_path(dish.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end

  it 'and can access your dishes' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    dish = user.restaurant.dishes.create!(name: 'Parmegiana', description: 'É bom!')

    #Act
    visit root_path
    click_on 'Pratos'
    click_on 'Parmegiana'

    #Assert
    expect(current_path).to eq dish_path(dish.id)
    expect(page).to have_content('Parmegiana')
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
  
  it 'and cant create dish with invalid image format' do
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
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_file.txt'))
    end
    click_on 'Salvar prato'

    #Assert
    expect(page).to have_selector('form#create-dish-form')
    expect(page).to have_content('Imagem deve ser uma imagem do tipo PNG ou JPG')
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