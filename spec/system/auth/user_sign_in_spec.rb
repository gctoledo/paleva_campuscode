require 'rails_helper'

describe 'User visits login page' do 
  it 'and login with restaurant already registered' do
    #Arrange
    r = Restaurant.create!(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', code: '245USD')
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: r.id)

    #Act
    visit root_path
    within('#login-form') do
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'Senha', with: 'password123456'
    end
    click_on 'Entrar'
    
    #Assert
    expect(page).to have_content(user.first_name)
    expect(page).to have_content('Proprietário')
  end

  it 'and login with no restaurant registered' do
    #Arrange
    User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')

    #Act
    visit root_path
    within('#login-form') do
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'Senha', with: 'password123456'
    end
    click_on 'Entrar'
    
    #Assert
    expect(current_path).to eq new_restaurants_path
    expect(page).to have_content('Proprietário')
  end

  it 'and tries to log in with invalid params' do
    #Arrange
    User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')

    #Act
    visit root_path
    within('#login-form') do
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'Senha', with: 'invalid_password'
    end
    click_on 'Entrar'
    
    #Assert
    expect(page).to have_content('E-mail ou senha inválidos.')
    expect(page).to have_content('Não possui conta? Cadastre-se agora!')
  end

  it 'and login as employee' do
    #Arrange
    @r = create_restaurant()
    User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    create_opentime(@r)
    pre_registered = @r.pre_registered_users.create!(email: 'mary@jane.com', cpf: CPF.generate)
    User.create!(email: pre_registered.email, cpf: pre_registered.cpf, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: @r.id)

    #Act
    visit root_path
    within('#login-form') do
      fill_in 'E-mail', with: 'mary@jane.com'
      fill_in 'Senha', with: 'password123456'
    end
    click_on 'Entrar'
    
    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Funcionário')
  end
end