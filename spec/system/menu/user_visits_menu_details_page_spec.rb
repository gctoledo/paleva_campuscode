require 'rails_helper'

describe 'User visits menu details page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    @menu = @r.menus.create!(name: 'Almoço')
  end

  it 'and is authenticated' do
    visit menus_path
    within('nav') do
      click_on 'Cardápios'
    end
    click_on 'Ver detalhes'
    
    expect(current_path).to eq menu_path(@menu)
  end

  it 'and is not authenticated' do
    logout()

    visit menu_path(@menu)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'and is kicked out because menu is from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    visit menu_path(@menu.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and sees menu drinks and dishes' do 
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save
    dish = @r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save
    @menu.drinks << drink
    @menu.dishes << dish
    
    visit menus_path
    click_on 'Ver detalhes'

    expect(page).to have_content('Almoço')
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Coca-cola')
  end

  it 'and cant see inactive dishes or drinks' do 
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.', active: false)
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save
    dish = @r.dishes.new(name: 'Parmegiana', description: 'É bom!', active: false)
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save
    @menu.drinks << drink
    @menu.dishes << dish
    
    visit menus_path
    click_on 'Ver detalhes'

    expect(page).to have_content('Almoço')
    expect(page).to have_content('Nenhum prato ativo neste cardápio.')
    expect(page).to have_content('Nenhuma bebida ativa neste cardápio.')
  end

  it 'and can see dishes or drinks portions' do 
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.portions.new(description: 'Lata', price: 5)
    drink.save
    @menu.drinks << drink
    
    visit menus_path
    click_on 'Ver detalhes'

    expect(page).to have_content('Almoço')
    expect(page).to have_content('Coca-cola')
    expect(page).to have_content('Lata')
    expect(page).to have_content('R$ 5,00')
  end
end