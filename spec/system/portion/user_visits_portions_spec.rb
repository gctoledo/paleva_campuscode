require 'rails_helper'

describe 'User visists portion' do 
  it 'through drinks page' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    drink = user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.portions.new(description: 'Lata', price: 5)
    drink.save

    #Act
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Coca-cola'

    #Assert
    expect(current_path).to eq drink_path(drink.id)
    expect(page).to have_content('Coca-cola')
    expect(page).to have_content('Lata')
    expect(page).to have_content('R$ 5,00')
  end

  it 'through dishes page' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    dish = user.restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.portions.new(description: 'Grande', price: 25)

    dish.save

    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'

    #Assert
    expect(current_path).to eq dish_path(dish.id)
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Grande')
    expect(page).to have_content('R$ 25,00')
  end

  it 'and have not portions registred' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    dish = user.restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save

    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'

    #Assert
    expect(current_path).to eq dish_path(dish.id)
    expect(page).to have_content('Você não possui porções cadastradas!')
  end
end