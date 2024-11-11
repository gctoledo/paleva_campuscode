require 'rails_helper'

describe 'User visits portion creation page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'through dish details page and sees all form inputs in creation form' do
    #Arrange
    dish = @r.dishes.new(name: 'Parmegiana', description: 'É bom!')
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
    click_on 'Adicionar porção'

    #Assert
    expect(current_path).to eq new_dish_portion_path(dish.id)
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Preço')
  end

  it 'through drink details page and sees all form inputs in creation form' do
    #Arrange
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save

    #Act
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Coca-cola'
    click_on 'Adicionar porção'

    #Assert
    expect(current_path).to eq new_drink_portion_path(drink.id)
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Preço')
  end

  it 'and cant create with invalid params' do
    #Arrange
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save

    #Act
    visit new_drink_portion_path(drink.id)
    click_on 'Salvar porção'

    #Assert
    expect(page).to have_selector('form#portion-form')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Preço não pode ficar em branco')
  end

  it 'and cant visit create page to dishes and drinks from another restaurant' do
    #Arrange
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save

    #Act
    visit new_drink_portion_path(drink.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and creates a portion' do
    #Arrange
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save

    #Act
    visit new_drink_portion_path(drink.id)
    within('#portion-form') do
      fill_in 'Descrição', with: 'Lata'
      fill_in 'Preço', with: '5.5'
    end
    click_on 'Salvar porção'

    #Assert
    expect(current_path).to eq drink_path(drink.id)
    expect(page).to have_content('Porção criada com sucesso.')
    expect(page).to have_content('Coca-cola')
    expect(page).to have_content('Lata')
  end
end