require 'rails_helper'

describe 'User visits dish details page' do
  before(:each) do
    @user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(@user)
    @r = create_restaurant(@user)
    create_opentime(@user)
    @dish = @r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    @dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @dish.save
  end

  it 'and is kicked out because dish is from another restaurant' do
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    create_opentime(second_user)
    login_as(second_user)

    visit dish_path(@dish.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end

  it 'and disable the dish' do
    visit root_path
    within('nav') do
    click_on 'Pratos'
    end
    click_on 'Parmegiana'
    click_on 'Desativar'

    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Prato desativado com sucesso.')
    expect(page).to have_content('Ativar')
    expect(page).to have_content('Parmegiana')
  end

  it 'and active the dish' do
    @dish.update!(active: false)

    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'
    click_on 'Ativar'

    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Prato ativado com sucesso.')
    expect(page).to have_content('Desativar')
    expect(page).to have_content('Parmegiana')
  end

  it 'and sees dish tags' do
    tag = @r.tags.create!(name: 'Vegetariano')
    @dish.tags << tag

    visit root_path
    within('nav') do
    click_on 'Pratos'
    end
    click_on 'Parmegiana'

    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Vegetariano')
  end
end