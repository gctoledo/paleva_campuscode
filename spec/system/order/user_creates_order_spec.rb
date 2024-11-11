require 'rails_helper'

describe 'User visits order creation page' do
  before(:each) do
    @r = create_restaurant()
    user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(user)
    create_opentime(@r)
  end

  it 'through orders page' do
    visit root_path
    within('nav') do
      click_on 'Pedidos'
    end
    click_on 'Novo pedido'

    expect(current_path).to eq new_order_path
  end

  it 'through menu details page' do
    menu = @r.menus.create!(name: 'Almoço')
    create_drink(restaurant: @r)
    dish = create_dish(restaurant: @r)
    menu.dishes << dish

    visit root_path
    within('nav') do
      click_on 'Cardápios'
    end
    click_on 'Ver detalhes'
    click_on 'Novo pedido'

    expect(current_path).to eq new_menu_order_path(menu)
    expect(page).to have_content('Parmegiana')
    expect(page).not_to have_content('Coca-cola')
  end

  it 'and sees all form inputs in creation form' do
    create_drink(restaurant: @r)
    create_dish(restaurant: @r)

    visit new_order_path

    expect(page).to have_field('Nome do cliente')
    expect(page).to have_field('Telefone do cliente')
    expect(page).to have_field('E-mail do cliente')
    expect(page).to have_field('CPF do cliente (opcional)')
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Coca-cola')
  end

  it 'and creates a order through orders page' do
    drink = create_drink(restaurant: @r)
    dish = create_dish(restaurant: @r)

    visit new_order_path
    within('#order-form') do
      fill_in 'Nome do cliente', with: 'John Doe'
      fill_in 'Telefone do cliente', with: '11111111111'
      select 'Prato - R$ 25.00', from: "order[order_items][dishes][#{dish.id}][portion_id]"
      fill_in "order[order_items][dishes][#{dish.id}][note]", with: 'Sem cebola, por favor.'

      select 'Lata - R$ 5.00', from: "order[order_items][drinks][#{drink.id}][portion_id]"
      fill_in "order[order_items][drinks][#{drink.id}][note]", with: 'Bem gelada, por favor.'
    end
    click_on 'Salvar pedido'

    expect(page).to have_content('John Doe')
    expect(page).to have_content('Aguardando confirmação')
    expect(page).to have_content('11111111111')
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Sem cebola, por favor.')
    expect(page).to have_content('Coca-cola')
    expect(page).to have_content('Bem gelada, por favor.')
  end

  it 'and creates a order through menu details page' do
    menu = @r.menus.create!(name: 'Almoço')
    drink = create_drink(restaurant: @r)
    dish = create_dish(restaurant: @r)
    menu.drinks << drink
    menu.dishes << dish

    visit new_menu_order_path(menu)
    within('#order-form') do
      fill_in 'Nome do cliente', with: 'John Doe'
      fill_in 'Telefone do cliente', with: '11111111111'
      select 'Prato - R$ 25.00', from: "order[order_items][dishes][#{dish.id}][portion_id]"
      fill_in "order[order_items][dishes][#{dish.id}][note]", with: 'Sem cebola, por favor.'

      select 'Lata - R$ 5.00', from: "order[order_items][drinks][#{drink.id}][portion_id]"
      fill_in "order[order_items][drinks][#{drink.id}][note]", with: 'Bem gelada, por favor.'
    end
    click_on 'Salvar pedido'

    expect(page).to have_content('John Doe')
    expect(page).to have_content('Aguardando confirmação')
    expect(page).to have_content('11111111111')
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Sem cebola, por favor.')
    expect(page).to have_content('Coca-cola')
    expect(page).to have_content('Bem gelada, por favor.')
  end

  it 'and cant visit creation page from menus from another restaurant' do
    second_restaurant = Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456', restaurant_id: second_restaurant.id)
    create_opentime(second_restaurant)
    login_as(second_user)
    menu = @r.menus.create!(name: 'Almoço')
    drink = create_drink(restaurant: @r)
    dish = create_dish(restaurant: @r)
    menu.drinks << drink
    menu.dishes << dish

    visit new_menu_order_path(menu)

    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado')
  end
end