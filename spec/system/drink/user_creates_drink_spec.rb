require 'rails_helper'

describe 'User visits drink creation page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'and is authenticated' do
    visit root_path
    within('nav') do
      click_on 'Bebidas'
    end
    click_on 'Cadastrar'

    expect(current_path).to eq new_drink_path
  end

  it 'and is not authenticated' do
    logout()

    visit new_drink_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'and sees all form inputs in creation form' do
    #Act
    visit new_drink_path

    #Assert
    expect(current_path).to eq new_drink_path
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Alcoólica?')
    expect(page).to have_field('Imagem')
  end

  it 'and is kicked out because is employee' do
    employee = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: @r.id, role: 1)
    login_as(employee)

    visit new_drink_path

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and cant create drink with incorrect params' do
    #Act
    visit new_drink_path
    click_on 'Salvar bebida'

    #Assert
    expect(page).to have_selector('form#drink-form')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
  end

  it 'and creates a drink' do
    #Act
    visit new_drink_path
    within('#drink-form') do
      fill_in 'Nome', with: 'Coca-cola'
      fill_in 'Descrição', with: 'Bebida de cola'
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    end
    click_on 'Salvar bebida'

    #Assert
    expect(current_path).to eq drinks_path
    expect(page).to have_content('Bebida cadastrada com sucesso!')
  end

  it 'and created drinks must be activated' do
    #Act
    visit new_drink_path
    within('#drink-form') do
      fill_in 'Nome', with: 'Coca-cola'
      fill_in 'Descrição', with: 'Bebida de cola'
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    end
    click_on 'Salvar bebida'

    #Assert
    expect(page).to have_content('Ativo')
  end
end