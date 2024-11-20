require 'rails_helper'

describe 'User visits menu creation page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'and is authenticated' do
    visit root_path
    click_on 'Cadastrar'

    expect(current_path).to eq new_menu_path
  end

  it 'and is not authenticated' do
    logout()

    visit new_menu_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'and sees all form inputs in creation form' do
    visit new_menu_path

    expect(current_path).to eq new_menu_path
    expect(page).to have_field('Nome')
    expect(page).to have_content('Você não possui pratos cadastrados')
    expect(page).to have_content('Você não possui bebidas cadastradas')
  end

  it 'and is kicked out because is employee' do
    employee = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: @r.id, role: 1)
    login_as(employee)

    visit new_menu_path

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and cant create menu with incorrect params' do
    visit new_menu_path
    click_on 'Salvar cardápio'

    expect(page).to have_selector('form#menu-form')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'and cant create menu if only 1 date is provided' do
    visit new_menu_path
    within('#menu-form') do
      fill_in 'Nome', with: 'Almoço'
      fill_in 'Data de abertura', with: (Date.today).strftime('%Y-%m-%d')
    end
    click_on 'Salvar cardápio'

    expect(page).to have_selector('form#menu-form')
    expect(page).to have_content('Data de encerramento não pode ficar em branco')
  end

  it 'and cant create menu if end date is before than start date' do
    visit new_menu_path
    within('#menu-form') do
      fill_in 'Nome', with: 'Almoço'
      fill_in 'Data de abertura', with: (Date.today).strftime('%Y-%m-%d')
      fill_in 'Data de encerramento', with: (Date.today - 7).strftime('%Y-%m-%d')
    end
    click_on 'Salvar cardápio'

    expect(page).to have_selector('form#menu-form')
    expect(page).to have_content('Data de encerramento deve ser posterior à data de início')
  end

  it 'and cant create menu if start date is before than today' do
    visit new_menu_path
    within('#menu-form') do
      fill_in 'Nome', with: 'Almoço'
      fill_in 'Data de abertura', with: (Date.today - 1).strftime('%Y-%m-%d')
      fill_in 'Data de encerramento', with: (Date.today + 7).strftime('%Y-%m-%d')
    end
    click_on 'Salvar cardápio'

    expect(page).to have_selector('form#menu-form')
    expect(page).to have_content('Data de abertura não pode ser anterior à data atual')
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

  it 'and creates a menu with no drinks or dishes and no expiration date' do
    visit new_menu_path
    within('#menu-form') do
      fill_in 'Nome', with: 'Almoço'
    end
    click_on 'Salvar cardápio'

    expect(current_path).to eq menus_path
    expect(page).to have_content('Almoço')
  end

  it 'and creates a menu with expiration date' do
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
      fill_in 'Data de abertura', with: (Date.today).strftime('%Y-%m-%d')
      fill_in 'Data de encerramento', with: (Date.today + 7).strftime('%Y-%m-%d')
    end
    click_on 'Salvar cardápio'

    expect(current_path).to eq menus_path
    expect(page).to have_content('Almoço')
    expect(page).to have_content('Expira em 7 dia(s)')
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