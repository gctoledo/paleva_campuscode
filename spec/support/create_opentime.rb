def create_opentime(restaurant, week_day: 0, open: '08:30', close: '18:00', closed: false)
  Opentime.create!(week_day: week_day, open: open, close: close, closed: closed, restaurant: restaurant)
end