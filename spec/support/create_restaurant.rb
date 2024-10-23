def create_restaurant(user_id)
  Restaurant.create!(trade_name: 'Burguer King', legal_name: 'Burguer King', cnpj: CNPJ.generate, address: 'United Stated', phone: '11111111111', email: 'burger@king.com', code: '245USD', user_id: user_id)
end