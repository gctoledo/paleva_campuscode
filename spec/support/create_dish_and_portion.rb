def create_dish(restaurant:, name: 'Parmegiana', description: 'É bom!', portion_description: 'Prato', portion_price: 25)
  dish = restaurant.dishes.new(name: name, description: description)
  dish.image.attach(
    io: File.open('spec/fixtures/test_image.png'),
    filename: 'test_image.png',
    content_type: 'image/png'
  )
  dish.portions.new(description: portion_description, price: portion_price)
  dish.save

  dish
end