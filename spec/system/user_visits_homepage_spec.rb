require 'rails_helper'

describe 'User visits homepage' do
  it 'and is kicked out because he is not authenticated' do
    #Arrange
    
    #Act
    visit root_path

    #Assert
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(page).to have_content('Não possui conta? Cadastre-se agora!')
  end
end