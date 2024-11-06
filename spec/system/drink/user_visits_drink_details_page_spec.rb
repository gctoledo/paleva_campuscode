require 'rails_helper'

describe 'User visits drink details page' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    create_restaurant(user)
    create_opentime(user)
    @drink = user.restaurant.drinks.new(name: 'Coca-cola', description: 'Refrigerante de cola.')
    @drink.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @drink.save
  end

  it 'and is kicked out because drink is from another restaurant' do
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    create_opentime(second_user)
    login_as(second_user)

    visit drink_path(@drink.id)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end

  it 'and disable the drink' do
    visit drink_path(@drink.id)
    click_on 'Desativar'

    expect(current_path).to eq drink_path(@drink.id)
    expect(page).to have_content('Bebida desativada com sucesso.')
    expect(page).to have_content('Ativar')
    expect(page).to have_content('Coca-cola')
  end

  it 'and active the drink' do
    @drink.update!(active: false)

    visit drink_path(@drink.id)
    click_on 'Ativar'

    expect(current_path).to eq drink_path(@drink.id)
    expect(page).to have_content('Bebida ativada com sucesso.')
    expect(page).to have_content('Desativar')
    expect(page).to have_content('Coca-cola')
  end

  it 'and deletes the drink' do
    visit drink_path(@drink.id)
    click_on 'Apagar'

    expect(current_path).to eq drinks_path
    expect(page).to have_content('Bebida excluída com sucesso.')
    expect(page).not_to have_content('Coca-cola')
  end
end