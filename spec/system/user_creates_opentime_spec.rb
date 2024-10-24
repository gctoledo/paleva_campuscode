require 'rails_helper'

describe 'User visits opentime creation page' do
  it 'and sees all form inputs' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)

    #Act
    visit root_path
    click_on 'Meus horários'
    click_on 'Cadastrar'

    #Assert
    expect(current_path).to eq new_opentime_path
    expect(page).to have_field('Dia da Semana')
    expect(page).to have_field('Horário de Abertura')
    expect(page).to have_field('Horário de Fechamento')
    expect(page).to have_field('Fechado')
  end

  it 'and cant create a opentime when week day already registered' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    r = create_restaurant(user)
    r.opentimes.create!(week_day: 0, open: '08:30', close: '18:00')

    #Act
    visit new_opentime_path
    within('#create-opentime-form') do
      select 'Domingo', from: 'opentime_week_day'
      fill_in 'Horário de Abertura', with: '08:30'
      fill_in 'Horário de Fechamento', with: '18:00'
      click_on 'Salvar horário'
    end

    #Assert
    expect(page).to have_selector('form#create-opentime-form')
    expect(page).to have_content('Você já cadastratou esse dia.')
  end

  it 'and cant create a opentime with invalid params' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)

    #Act
    visit new_opentime_path
    click_on 'Salvar horário'

    #Assert
    expect(page).to have_selector('form#create-opentime-form')
    expect(page).to have_content('Horário de abertura não pode ficar em branco')
    expect(page).to have_content('Horário de encerramento não pode ficar em branco')
  end

  it 'and cant create a opentime because close time is less then open time' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)

    #Act
    visit new_opentime_path
    within('#create-opentime-form') do
      select 'Domingo', from: 'opentime_week_day'
      fill_in 'Horário de Abertura', with: '18:30'
      fill_in 'Horário de Fechamento', with: '08:00'
      click_on 'Salvar horário'
    end

    #Assert
    expect(page).to have_selector('form#create-opentime-form')
    expect(page).to have_content('Horário de encerramento deve ser maior que o horário de abertura')
  end

  it 'and creates a opentime' do
    #Arrange
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)

    #Act
    visit new_opentime_path
    within('#create-opentime-form') do
      select 'Domingo', from: 'opentime_week_day'
      fill_in 'Horário de Abertura', with: '08:30'
      fill_in 'Horário de Fechamento', with: '18:00'
      click_on 'Salvar horário'
    end

    #Assert
    expect(current_path).to eq opentimes_path
    expect(page).to have_content('Horário cadastrado com sucesso!')
  end
end