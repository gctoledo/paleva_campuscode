require 'rails_helper'

describe 'User visits dish details page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
    @dish = @r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    @dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @dish.save
  end

  it 'and is authenticated' do
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'

    expect(current_path).to eq dish_path(@dish)
    expect(page).to have_content('Parmegiana')
  end

  it 'and is not authenticated' do
    logout()

    visit dish_path(@dish)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'and is kicked out because dish is from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    visit dish_path(@dish.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end

  it 'and disable the dish' do
    visit dish_path(@dish.id)
    click_on 'Desativar'

    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Prato desativado com sucesso.')
    expect(page).to have_content('Ativar')
    expect(page).to have_content('Parmegiana')
  end

  it 'and active the dish' do
    @dish.update!(active: false)

    visit dish_path(@dish.id)
    click_on 'Ativar'

    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Prato ativado com sucesso.')
    expect(page).to have_content('Desativar')
    expect(page).to have_content('Parmegiana')
  end

  it 'and sees dish tags' do
    tag = @r.tags.create!(name: 'Vegetariano')
    @dish.tags << tag

    visit dish_path(@dish.id)

    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Vegetariano')
  end

  it 'and deletes the dish' do
    visit dish_path(@dish.id)
    click_on 'Apagar'

    expect(current_path).to eq dishes_path
    expect(page).to have_content('Prato excluído com sucesso.')
    expect(page).not_to have_content('Parmegiana')
  end
end