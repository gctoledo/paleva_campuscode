require 'rails_helper'

describe 'User creates a tag' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    @r = create_restaurant(user)
    create_opentime(user)
  end

  it 'from tag creation page' do
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Marcadores'
    click_on 'Cadastrar'
    within('#tag-form') do
      fill_in 'Nome', with: 'Vegetariano'
    end
    click_on 'Salvar marcador'

    expect(current_path).to eq tags_path
    expect(page).to have_content 'Vegetariano'
  end

  it 'but failed because tag already exists' do
    @r.tags.create(name: 'Vegetariano')

    visit new_tag_path
    within('#tag-form') do
      fill_in 'Nome', with: 'Vegetariano'
    end
    click_on 'Salvar marcador'

    expect(page).to have_content 'Nome já está em uso'
  end

  it 'from dish creation page' do
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Cadastrar'
    within('#dish-form') do
      fill_in 'Nome', with: 'Parmegiana'
      fill_in 'Descrição', with: 'É um prato italiano feito com berinjela frita e fatiada, coberta com queijo e molho de tomate e depois assada.'
      attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
      fill_in 'new_tags', with: 'Vegetariano, sem glúten'
    end
    click_on 'Salvar prato'
    click_on 'Parmegiana'

    expect(page).to have_content 'Parmegiana'
    expect(page).to have_content 'Vegetariano'
    expect(page).to have_content 'Sem glúten'
  end
end