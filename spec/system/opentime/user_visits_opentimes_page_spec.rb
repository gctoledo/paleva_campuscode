require 'rails_helper'

describe 'Users visits opentimes page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    create_opentime(@r)
    login_as(user)
  end

  it 'and have no opentimes registered' do
    Opentime.destroy_all

    visit root_path
    within('nav') do
      click_on 'Horários'
    end

    expect(page).to have_content('Você não possui horários cadastrados. Por favor, adicione-os.')
  end

  it 'and sees registered opentimes' do 
    create_opentime(@r, week_day: 1, closed: true)
    
    visit opentimes_path

    expect(page).to have_content('Domingo')
    expect(page).to have_content('Aberto')
    expect(page).to have_content('08:30')
    expect(page).to have_content('18:00')
    expect(page).to have_content('Segunda-feira')
    expect(page).to have_content('Fechado')
    expect(page).to have_content('Terça-feira')
    expect(page).to have_content('Quarta-feira')
    expect(page).to have_content('Quinta-feira')
    expect(page).to have_content('Sexta-feira')
    expect(page).to have_content('Sábado')
  end
end