require 'rails_helper'

describe 'User visits drinks pages' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    @drink = user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    @drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @drink.save
  end

  it 'and sees all drinks' do 
    #Act
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end

    #Assert
    expect(current_path).to eq drinks_path
    expect(page).to have_content('Coca-cola')
  end

  it 'and can access your drink' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Coca-cola'

    #Assert
    expect(current_path).to eq drink_path(@drink.id)
    expect(page).to have_content('Coca-cola')
  end

  it 'and can see status of your drinks' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Coca-cola'

    #Assert
    expect(page).to have_content('Ativo')
    expect(page).to have_content('Coca-cola')
  end
end