def create_opentime(user)
  Opentime.create!(week_day: 0, open: '08:30', close: '18:00', restaurant: user.restaurant)
end