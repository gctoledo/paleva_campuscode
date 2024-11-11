require 'rails_helper'

describe 'User visits dish edition page' do
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

  it 'and sees all form inputs' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'
    click_on 'Editar'

    #Assert
    expect(current_path).to eq(edit_dish_path(@dish.id))
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Calorias')
    expect(page).to have_field('Imagem')
  end

  it 'and cant visit edit dish page from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)

    #Act
    visit edit_dish_path(@dish.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso não autorizado'
  end

  it 'and can edit dish' do
    #Act
    visit edit_dish_path(@dish.id)
    within('#dish-form') do
      fill_in 'Descrição', with: 'É um prato italiano feito com berinjela frita e fatiada, coberta com queijo e molho de tomate e depois assada.'
      click_on 'Salvar prato'
    end

    #Assert
    expect(current_path).to eq(dish_path(@dish.id))
    expect(page).to have_content('Prato atualizado com sucesso')
  end

  it 'and can create new tags' do
    #Act
    visit edit_dish_path(@dish.id)
    within('#dish-form') do
      fill_in 'new_tags', with: 'Vegetariano, sem glúten'
      click_on 'Salvar prato'
    end

    #Assert
    expect(current_path).to eq(dish_path(@dish.id))
    expect(page).to have_content('Prato atualizado com sucesso')
    expect(page).to have_content('Vegetariano')
    expect(page).to have_content('Sem glúten')
  end

  it 'and can select tags already registered to your dish' do
    @r.tags.create!(name: 'Vegetariano')

    #Act
    visit edit_dish_path(@dish.id)
    within('#dish-form') do
      check 'Vegetariano'
      click_on 'Salvar prato'
    end

    #Assert
    expect(current_path).to eq(dish_path(@dish.id))
    expect(page).to have_content('Prato atualizado com sucesso')
    expect(page).to have_content('Vegetariano')
  end
end