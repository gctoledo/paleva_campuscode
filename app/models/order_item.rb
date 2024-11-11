class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :portion
  belongs_to :dish, optional: true
  belongs_to :drink, optional: true

  validates :price, presence: true
end
