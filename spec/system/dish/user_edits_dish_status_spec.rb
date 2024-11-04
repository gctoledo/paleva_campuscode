require 'rails_helper'

describe 'User edits dish status' do
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
    @dish.save
  end

  it 'to disable dish' do
    #Act
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end
    click_on 'Parmegiana'
    click_on 'Desativar'

    #Assert
    expect(current_path).to eq dish_path(@dish.id)
    expect(page).to have_content('Prato desativado com sucesso.')
    expect(page).to have_content('Ativar')
    expect(page).to have_content('Parmegiana')
  end
end