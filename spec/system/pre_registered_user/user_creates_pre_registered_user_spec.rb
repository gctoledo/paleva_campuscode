require 'rails_helper'

describe 'User visits pre registered user creation page' do
  before(:each) do
    @r = create_restaurant()
    @user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(@user)
    create_opentime(@r)
  end

  it 'and sees all form inputs in creation form' do
    visit root_path
    within('nav') do
      click_on 'Funcionários'
    end
    click_on 'Cadastrar'

    expect(current_path).to eq new_pre_registered_user_path
    expect(page).to have_field('E-mail')
    expect(page).to have_field('CPF')
  end

  it 'and is kicked out because is employee' do
    employee = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: @r.id, role: 1)
    login_as(employee)

    visit new_pre_registered_user_path

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and cant create user with incorrect params' do
    visit new_pre_registered_user_path
    click_on 'Cadastrar usuário'

    expect(page).to have_selector('form#employee-form')
    expect(page).to have_content('E-mail não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
  end

  it 'and cant create user with e-mail already used' do
    visit new_pre_registered_user_path
    within('#employee-form') do
      fill_in 'E-mail', with: 'john@doe.com'
      fill_in 'CPF', with: CPF.generate
    end
    click_on 'Cadastrar usuário'

    expect(page).to have_selector('form#employee-form')
    expect(page).to have_content('E-mail já está em uso')
  end

  it 'and cant create user with CPF already used' do
    visit new_pre_registered_user_path
    within('#employee-form') do
      fill_in 'E-mail', with: 'mary@jane.com'
      fill_in 'CPF', with: @user.cpf
    end
    click_on 'Cadastrar usuário'

    expect(page).to have_selector('form#employee-form')
    expect(page).to have_content('CPF já está em uso')
  end

  it 'and creates a user' do
    visit new_pre_registered_user_path
    within('#employee-form') do
      fill_in 'E-mail', with: 'mary@jane.com'
      fill_in 'CPF', with: CPF.generate
    end
    click_on 'Cadastrar usuário'

    expect(current_path).to eq pre_registered_users_path
    expect(page).to have_content('Usuário pré-cadastrado com sucesso.')
    expect(page).to have_content('Não utilizado')
  end
end