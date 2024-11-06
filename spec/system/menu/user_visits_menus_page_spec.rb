require 'rails_helper'

describe 'User visits menus page' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    @r = create_restaurant(user)
    create_opentime(user)
  end

  it 'and have no menus registered' do
    visit root_path

    expect(page).to have_content('Nenhum cardápio cadastrado.')
  end

  it 'and sees all menus' do 
    @r.menus.create!(name: 'Almoço')
    
    visit root_path

    expect(page).to have_content('Almoço')
  end
end