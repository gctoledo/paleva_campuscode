require 'rails_helper'

describe 'User visits registration page' do
  it 'and sees all form inputs' do
    # Arrange

    # Act
    visit root_path
    click_on 'Não possui conta? Cadastre-se agora!'

    # Assert
    expect(page).to have_field('Nome')
    expect(page).to have_field('Sobrenome')
    expect(page).to have_field('E-mail')
    expect(page).to have_field('CPF')
    expect(page).to have_field('Senha')
    expect(page).to have_field('Senha de confirmação')
  end

  it 'and sign up' do
    #Arrange

    #Act
    visit root_path
    click_on 'Não possui conta? Cadastre-se agora!'
    within('form') do
      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'CPF', with: CPF.generate
      fill_in 'Senha', with: 'password123456'
      fill_in 'Senha de confirmação', with: 'password123456'
    end
    click_on 'Cadastrar'
    
    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('John')
  end

  it 'and try sign up with incorrect params' do
    #Arrange

    #Act
    visit root_path
    click_on 'Não possui conta? Cadastre-se agora!'
    click_on 'Cadastrar'
    
    #Assert
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Sobrenome não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
    expect(page).to have_content('CPF é inválido')
    expect(page).to have_content('E-mail não pode ficar em branco')
    expect(page).to have_content('Senha não pode ficar em branco')
  end

  it 'and try sign up with incorrect password confirmation' do
    #Arrange

    #Act
    visit root_path
    click_on 'Não possui conta? Cadastre-se agora!'
    within('form') do
      fill_in 'Nome', with: 'John'
      fill_in 'Sobrenome', with: 'Doe'
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'CPF', with: CPF.generate
      fill_in 'Senha', with: 'password123456'
      fill_in 'Senha de confirmação', with: 'password12345'
    end
    click_on 'Cadastrar'
    
    #Assert
    expect(page).to have_content('Senha de confirmação não é igual a Senha')
  end
end