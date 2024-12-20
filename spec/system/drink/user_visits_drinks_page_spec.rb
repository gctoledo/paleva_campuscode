require 'rails_helper'

describe 'User visits drinks pages' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    @drink = user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    @drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @drink.save
  end

  it 'and is authenticated' do
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end

    expect(current_path).to eq drinks_path
    expect(page).to have_content('Coca-cola')
  end

  it 'and is not authenticated' do
    logout()

    visit drinks_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'and sees all drinks' do 
    #Act
    visit drinks_path

    #Assert
    expect(current_path).to eq drinks_path
    expect(page).to have_content('Coca-cola')
  end

  it 'and can see status of your drinks' do
    #Act
    visit drinks_path

    #Assert
    expect(page).to have_content('Ativo')
    expect(page).to have_content('Coca-cola')
  end
end