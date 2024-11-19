require 'rails_helper'

describe 'User visits menus page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'and have no menus registered' do
    visit root_path

    expect(page).to have_content('Nenhum cardápio cadastrado.')
  end

  it 'and cant see expired menus' do
    @r.menus.create!(name: 'Almoço', start_date: (Date.today), end_date: (Date.today + 8))
    

    travel_to(Date.today + 10) do
      visit root_path

      expect(page).to have_content('Nenhum cardápio cadastrado.')
      expect(page).not_to have_content('Almoço')
    end
  end

  it 'and cant see menus before then start date' do
    @r.menus.create!(name: 'Almoço', start_date: (Date.today), end_date: (Date.today + 8))
    

    travel_to(Date.today - 1) do
      visit root_path

      expect(page).to have_content('Nenhum cardápio cadastrado.')
      expect(page).not_to have_content('Almoço')
    end
  end

  it 'and sees all menus' do 
    @r.menus.create!(name: 'Almoço')
    @r.menus.create!(name: 'Jantar', start_date: (Date.today), end_date: (Date.today + 7))
    
    visit root_path

    expect(page).to have_content('Almoço')
    expect(page).to have_content('Jantar')
    expect(page).to have_content('Expira em 7 dia(s)')
  end
end