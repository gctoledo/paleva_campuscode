require 'rails_helper'

describe 'User visits tags page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'and have not tag registered' do
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Marcadores'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Você não possui marcadores cadastrados.'
  end

  it 'and already have tag registered' do
    @r.tags.create!(name: 'Vegetariano')

    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Marcadores'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Vegetariano'
  end
end