require 'rails_helper'

describe 'User deletes tag' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    @r = create_restaurant(user)
    create_opentime(user)
  end

  it 'from tags page' do
    @r.tags.create!(name: 'Vegetariano')

    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Marcadores'
    click_on 'Excluir'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Você não possui marcadores cadastrados.'
  end
end