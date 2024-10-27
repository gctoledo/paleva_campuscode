require 'rails_helper'

describe 'User visits drink creation page' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
  end

  it 'and sees all form inputs in creation form' do
    #Act
    visit root_path
    click_on 'Bebidas'
    click_on 'Cadastrar'

    #Assert
    expect(current_path).to eq new_drink_path
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Alcoólica?')
    expect(page).to have_field('Imagem')
  end

  it 'and cant create drink with incorrect params' do
    #Act
    visit new_drink_path
    click_on 'Salvar bebida'

    #Assert
    expect(page).to have_selector('form#create-drink-form')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
  end

  it 'and creates a drink' do
    #Act
    visit new_drink_path
    within('#create-drink-form') do
      fill_in 'Nome', with: 'Coca-cola'
      fill_in 'Descrição', with: 'Bebida de cola'
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    end
    click_on 'Salvar bebida'

    #Assert
    expect(current_path).to eq drinks_path
    expect(page).to have_content('Bebida cadastrada com sucesso!')
  end
end