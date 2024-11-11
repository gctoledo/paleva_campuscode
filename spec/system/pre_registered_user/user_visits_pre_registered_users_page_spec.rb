require 'rails_helper'

describe 'User visits pre registered users page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'and have no pre registered users registered' do
    visit root_path
    within('nav') do
      click_on 'Funcionários'
    end

    expect(page).to have_content('Não há usuários pré-cadastrados no momento.')
  end

  it 'and sees all employees' do
    employe = @r.pre_registered_users.create!(email: 'mary@jane.com', cpf: CPF.generate)

    visit pre_registered_users_path

    expect(page).to have_content(employe.email)
    expect(page).to have_content(employe.cpf)
    expect(page).to have_content('Não utilizado')
  end
end