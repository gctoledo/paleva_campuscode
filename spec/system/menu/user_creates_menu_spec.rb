require 'rails_helper'

describe 'User visits menu creation page' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    @r = create_restaurant(user)
    create_opentime(user)
  end

  it 'and sees all form inputs in creation form' do
    visit root_path
    click_on 'Cadastrar'

    expect(current_path).to eq new_menu_path
    expect(page).to have_field('Nome')
    expect(page).to have_content('Você não possui pratos cadastrados')
    expect(page).to have_content('Você não possui bebidas cadastradas')
  end

  it 'and cant create menu with incorrect params' do
    visit new_menu_path
    click_on 'Salvar cardápio'

    expect(page).to have_selector('form#menu-form')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'and cant create menus with same name' do
    @r.menus.create!(name: 'Almoço')

    visit new_menu_path
    within('#menu-form') do
      fill_in 'Nome', with: 'Almoço'
    end
    click_on 'Salvar cardápio'

    expect(page).to have_selector('form#menu-form')
    expect(page).to have_content('Nome já está em uso')
  end

  it 'and creates a menu with no drinks and dishes' do
    visit new_menu_path
    within('#menu-form') do
      fill_in 'Nome', with: 'Almoço'
    end
    click_on 'Salvar cardápio'

    expect(current_path).to eq menus_path
    expect(page).to have_content('Almoço')
  end

  it 'and creates a menu with drinks and dishes' do
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

    visit new_menu_path
    within('#menu-form') do
      fill_in 'Nome', with: 'Almoço'
      check 'Parmegiana'
      check 'Coca-cola'
    end
    click_on 'Salvar cardápio'

    expect(current_path).to eq menus_path
    expect(page).to have_content('Almoço')
  end
end