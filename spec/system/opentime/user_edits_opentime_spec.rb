require 'rails_helper'

describe 'User visits opentime edition page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    @opentime = create_opentime(@r)
    login_as(user)
  end

  it 'and sees all form inputs' do
    visit root_path
    within('nav') do
      click_on 'Horários'
    end
    click_on 'Domingo'

    expect(current_path).to eq edit_opentime_path(@opentime)
    expect(page).to have_content('Domingo')
    expect(page).to have_field('Horário de abertura')
    expect(page).to have_field('Horário de encerramento')
    expect(page).to have_field('Fechado?')
  end

  it 'and is kicked out because is employee' do
    employee = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: @r.id, role: 1)
    login_as(employee)

    visit edit_opentime_path(@opentime.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and cant access opentime edition page from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    visit edit_opentime_path(@opentime.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and edits a opentime' do
    visit edit_opentime_path(@opentime.id)
    within('#opentime-form') do
      fill_in 'Horário de abertura', with: '09:30'
    end
    click_on 'Salvar horário'

    expect(current_path).to eq opentimes_path
    expect(page).to have_content('Domingo')
    expect(page).to have_content('Abertura: 09:30')
  end
end