class DishesTag < ApplicationRecord
  belongs_to :dish
  belongs_to :tag
end
