def create_drink(restaurant:, name: 'Coca-cola', description: 'Refrigerante de cola.', portion_description: 'Lata', portion_price: 5)
  drink = restaurant.drinks.new(name: name, description: description)
  drink.image.attach(
    io: File.open('spec/fixtures/test_image.png'),
    filename: 'test_image.png',
    content_type: 'image/png'
  )
  drink.portions.new(description: portion_description, price: portion_price)
  drink.save

  drink
end