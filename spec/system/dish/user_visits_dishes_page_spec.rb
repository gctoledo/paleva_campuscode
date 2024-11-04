require 'rails_helper'

describe 'User visits dishes pages' do
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

  it 'and cant access dishes from other restaurants' do
    #Arrange
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    create_opentime(second_user)
    login_as(second_user)

    #Act
    visit dish_path(@dish.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Acesso não autorizado.')
  end

  it 'and sees all dishes' do 
    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end

    #Assert
    expect(current_path).to eq dishes_path
    expect(page).to have_content('Parmegiana')
  end

  it 'and can access your dishes' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'

    #Assert
    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Parmegiana')
  end

  it 'and can see status of your dishes' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end

    #Assert
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Ativo')
  end

  it 'and can see created tags filter' do
    @r.tags.create!(name: 'Vegetariano')

    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end

    #Assert
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Vegetariano')
  end

  it 'and can filter dishes from tags' do
    #Arrange
    tag = @r.tags.create!(name: 'Vegetariano')
    @dish.tags << tag
    @dish.save
    second_dish = @user.restaurant.dishes.new(name: 'Macarronada', description: 'Também é bom!')
    second_dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    second_dish.save

    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Vegetariano'

    #Assert
    expect(page).to have_content('Parmegiana')
    expect(page).not_to have_content('Macarronada')
  end
end