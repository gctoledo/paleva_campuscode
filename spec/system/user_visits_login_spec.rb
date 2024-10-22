require 'rails_helper'

describe 'User visits login page' do 
  it 'and login' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: '51264637721', first_name: 'John', last_name: 'Doe', password: 'password123456')

    #Act
    visit root_path
    within('form') do
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'Senha', with: 'password123456'
    end
    click_on 'Entrar'
    
    #Assert
    expect(page).to have_content(user.first_name)
  end

  it 'and tries to log in with invalid params' do
    #Arrange
    User.create!(email: 'john@doe.com', cpf: '51264637721', first_name: 'John', last_name: 'Doe', password: 'password123456')

    #Act
    visit root_path
    within('form') do
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'Senha', with: 'invalid_password'
    end
    click_on 'Entrar'
    
    #Assert
    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(page).to have_content('Não possui conta? Cadastre-se agora!')
  end
end