require 'rails_helper'

describe 'User visits opentime creation page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
  end

  it 'and sees all form inputs' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Horários'
    end
    click_on 'Cadastrar'

    #Assert
    expect(current_path).to eq new_opentime_path
    expect(page).to have_field('Dia da Semana')
    expect(page).to have_field('Horário de Abertura')
    expect(page).to have_field('Horário de Fechamento')
    expect(page).to have_field('Fechado')
  end

  it 'and is kicked out because is employee' do
    employee = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: @r.id, role: 1)
    login_as(employee)

    visit new_opentime_path

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and cant create a opentime when week day already registered' do
    
    @r.opentimes.create!(week_day: 0, open: '08:30', close: '18:00')

    #Act
    visit new_opentime_path
    within('#create-opentime-form') do
      select 'Domingo', from: 'opentime_week_day'
      fill_in 'Horário de Abertura', with: '08:30'
      fill_in 'Horário de Fechamento', with: '18:00'
    end
    click_on 'Salvar horário'

    #Assert
    expect(page).to have_selector('form#create-opentime-form')
    expect(page).to have_content('Erro ao cadastrar o horário.')
    expect(page).to have_content('Dia da semana já foi cadastrado para esse restaurante')
  end

  it 'and cant create a opentime with invalid params' do
    #Act
    visit new_opentime_path
    click_on 'Salvar horário'

    #Assert
    expect(page).to have_selector('form#create-opentime-form')
    expect(page).to have_content('Horário de abertura não pode ficar em branco')
    expect(page).to have_content('Horário de encerramento não pode ficar em branco')
  end

  it 'and cant create a opentime because close time is less then open time' do
    #Act
    visit new_opentime_path
    within('#create-opentime-form') do
      select 'Domingo', from: 'opentime_week_day'
      fill_in 'Horário de Abertura', with: '18:30'
      fill_in 'Horário de Fechamento', with: '08:00'
    end
    click_on 'Salvar horário'

    #Assert
    expect(page).to have_selector('form#create-opentime-form')
    expect(page).to have_content('Horário de encerramento deve ser maior que o horário de abertura')
  end

  it 'and creates a opentime' do
    #Act
    visit new_opentime_path
    within('#create-opentime-form') do
      select 'Domingo', from: 'opentime_week_day'
      fill_in 'Horário de Abertura', with: '08:30'
      fill_in 'Horário de Fechamento', with: '18:00'
    end
    click_on 'Salvar horário'

    #Assert
    expect(current_path).to eq opentimes_path
    expect(page).to have_content('Horário cadastrado com sucesso!')
  end
end