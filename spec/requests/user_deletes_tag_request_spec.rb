require 'rails_helper'

describe 'User tries to delete tag' do
  it 'but cant delete tags from another restaurant' do
    first_user = User.create!(email: 'john@doe.com', cpf: CPF.generate, first_name: 'John', last_name: 'Doe', password: 'password123456')
    second_user = User.create!(email: 'mary@jane.com', cpf: CPF.generate, first_name: 'Mary', last_name: 'Jane', password: 'password123456')
    Restaurant.create!(trade_name: 'McDonalds', legal_name: 'McDonalds', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'mc@donalds.com', user: second_user)
    r = create_restaurant(first_user)
    create_opentime(first_user)
    create_opentime(second_user)
    tag = r.tags.create!(name: 'Vegetariano')

    login_as(second_user)
    delete(tag_path(tag.id))

    expect(response).to redirect_to root_path
    expect(response).not_to be_successful
  end
end