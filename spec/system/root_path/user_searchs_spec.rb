require 'rails_helper'

describe 'User searchs' do
  it 'from navbar in homepage' do
    #Arrange
    r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: r.id)
    login_as(user)
    create_opentime(r)
  
    drink = user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save

    dish = user.restaurant.dishes.new(name: 'Costela', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save
    
    #Act
    visit root_path
    within('#search-form') do
      fill_in 'Buque por pratos ou bebidas:', with: 'Co'
    end
    click_on 'Buscar'

    #Assert
    expect(current_path).to eq search_path
    expect(page).to have_content('Coca-cola')
    expect(page).to have_content('Costela')
  end

  it 'and cant find anything' do
    #Arrange
    r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: r.id)
    login_as(user)
    create_opentime(r)
    
    #Act
    visit root_path
    within('#search-form') do
      fill_in 'Buque por pratos ou bebidas:', with: 'Co'
    end
    click_on 'Buscar'

    #Assert
    expect(current_path).to eq search_path
    expect(page).to have_content('Nenhum cadastro encontrado!')
  end
end