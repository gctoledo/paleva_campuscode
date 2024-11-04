require 'rails_helper'

describe 'User visits price history page' do
  before(:each) do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    r = create_restaurant(user)
    create_opentime(user)
    @dish = r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    @dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    @p = @dish.portions.new(description: 'Grande', price: 25)
    @dish.save
  end

  it 'after create a new portion' do
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'
    click_on 'Grande'

    expect(page).to have_content 'Não houve alteração de preço dessa porção!'
  end

  it 'after update a portion price' do
    visit edit_dish_portion_path(@dish.id, @p.id)
    fill_in 'Preço', with: 30
    click_on 'Salvar porção'
    click_on 'Grande'

    expect(current_path).to eq price_history_dish_portion_path(@dish.id, @p.id)
    expect(page).to have_content 'R$ 25,00'
    expect(page).to have_content @p.price_histories.last.changed_at.strftime("%d/%m/%Y")
  end

  it 'and cant access price histories from other restaurants' do
    #Arrange
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    login_as(second_user)
    create_opentime(second_user)

    #Act
    visit price_history_dish_portion_path(@dish.id, @p.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end
end