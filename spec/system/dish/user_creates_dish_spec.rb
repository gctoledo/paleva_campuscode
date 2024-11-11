require 'rails_helper'

describe 'User visits dish creation page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'and sees all form inputs in creation form' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Cadastrar'

    #Assert
    expect(current_path).to eq new_dish_path
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Calorias')
    expect(page).to have_field('Imagem')
  end

  it 'and cant create dish with incorrect params' do
    #Act
    visit new_dish_path
    click_on 'Salvar prato'

    #Assert
    expect(page).to have_selector('form#dish-form')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
  end

  it 'and creates a dish' do
    #Act
    visit new_dish_path
    within('#dish-form') do
      fill_in 'Nome', with: 'Parmegiana'
      fill_in 'Descrição', with: 'É um prato italiano feito com berinjela frita e fatiada, coberta com queijo e molho de tomate e depois assada.'
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    end
    click_on 'Salvar prato'

    #Assert
    expect(current_path).to eq dishes_path
    expect(page).to have_content('Prato cadastrado com sucesso!')
  end

  it 'and created dishes must be activated' do
    #Act
    visit new_dish_path
    within('#dish-form') do
      fill_in 'Nome', with: 'Parmegiana'
      fill_in 'Descrição', with: 'É um prato italiano feito com berinjela frita e fatiada, coberta com queijo e molho de tomate e depois assada.'
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    end
    click_on 'Salvar prato'

    #Assert
    expect(page).to have_content('Ativo')
  end
end