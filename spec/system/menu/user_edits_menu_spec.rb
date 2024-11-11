require 'rails_helper'

describe 'User visits menu edition page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    @menu = @r.menus.create!(name: 'Almoço')
  end

  it 'and sees all form inputs' do
    visit root_path
    click_on 'Ver detalhes'
    click_on 'Editar'

    expect(current_path).to eq edit_menu_path(@menu.id)
    expect(page).to have_field('Nome')
  end

  it 'and is kicked out because is employee' do
    employee = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: @r.id, role: 1)
    login_as(employee)

    visit edit_menu_path(@menu.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and cant access menu edition page from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    visit edit_menu_path(@menu.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and edits a menu' do
    drink = @r.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    drink.save

    visit root_path
    click_on 'Ver detalhes'
    click_on 'Editar'
    within('#menu-form') do
      fill_in 'Nome', with: 'Jantar'
      check 'Coca-cola'
    end
    click_on 'Salvar cardápio'

    expect(current_path).to eq menu_path(@menu.id)
    expect(page).to have_content('Jantar')
    expect(page).to have_content('Coca-cola')
  end
end