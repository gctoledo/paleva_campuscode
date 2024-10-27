require 'rails_helper'

describe 'User visits dish edition page' do
  it 'and sees all form inputs' do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    r = create_restaurant(user)
    create_opentime(user)
    dish = r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save

    #Act
    visit root_path
    click_on 'Pratos'
    click_on 'Parmegiana'
    click_on 'Editar'

    #Assert
    expect(current_path).to eq(edit_dish_path(dish.id))
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Calorias')
    expect(page).to have_field('Imagem')
  end

  it 'and cant edit dishes from other restaurants' do
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    login_as(second_user)
    create_restaurant(first_user)
    create_opentime(first_user)
    create_opentime(second_user)
    dish = first_user.restaurant.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save

    #Act
    visit edit_dish_path(dish.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end

  it 'and can edit dish' do
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    login_as(user)
    r = create_restaurant(user)
    create_opentime(user)
    dish = r.dishes.new(name: 'Parmegiana', description: 'É bom!')
    dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    dish.save

    #Act
    visit edit_dish_path(dish.id)
    within('#dish-form') do
    fill_in 'Nome', with: 'Parmegiana'
    fill_in 'Descrição', with: 'É um prato italiano feito com berinjela frita e fatiada, coberta com queijo e molho de tomate e depois assada.'
    attach_file('Imagem', Rails.root.join('spec/fixtures/test_image.png'))
    click_on 'Salvar prato'
  end

    #Assert
    expect(current_path).to eq(dish_path(dish.id))
    expect(page).to have_content('Prato atualizado com sucesso')
  end
end