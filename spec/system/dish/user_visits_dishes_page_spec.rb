require 'rails_helper'

describe 'User visits dishes pages' do
  before(:each) do
    @r = create_restaurant()
    @user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456', restaurant_id: @r.id)
    login_as(@user)
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

    expect(current_path).to eq dishes_path
    expect(page).to have_content('Parmegiana')
  end

  it 'and is not authenticated' do
    logout()

    visit dishes_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  it 'and can see status of your dishes' do
    #Act
    visit dishes_path

    #Assert
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Ativo')
  end

  it 'and can see created tags filter' do
    @r.tags.create!(name: 'Vegetariano')

    #Act
    visit dishes_path

    #Assert
    expect(page).to have_content('Parmegiana')
    expect(page).to have_content('Vegetariano')
  end

  it 'and can filter dishes from tags' do
    #Arrange
    tag = @r.tags.create!(name: 'Vegetariano')
    @dish.tags << tag
    @dish.save
    second_dish = @r.dishes.new(name: 'Macarronada', description: 'Também é bom!')
    second_dish.image.attach(
      io: File.open('spec/fixtures/test_image.png'),
      filename: 'test_image.png',
      content_type: 'image/png'
    )
    second_dish.save

    #Act
    visit dishes_path
    click_on 'Vegetariano'

    #Assert
    expect(page).to have_content('Parmegiana')
    expect(page).not_to have_content('Macarronada')
  end
end