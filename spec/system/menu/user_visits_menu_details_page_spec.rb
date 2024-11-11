require 'rails_helper'

describe 'User visits menu details page' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    @r = create_restaurant(user)
    create_opentime(user)
    @menu = @r.menus.create!(name: 'Almoço')
  end

  it 'and is kicked out because menu is from another restaurant' do
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    login_as(second_user)
    create_opentime(second_user)

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
    
    visit root_path
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
    
    visit root_path
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
    
    visit root_path
    click_on 'Ver detalhes'

    expect(page).to have_content('Almoço')
    expect(page).to have_content('Coca-cola')
    expect(page).to have_content('Lata')
    expect(page).to have_content('R$ 5,00')
  end
end