def create_opentime(restaurant)
  Opentime.create!(week_day: 0, open: '08:30', close: '18:00', restaurant: restaurant)
end