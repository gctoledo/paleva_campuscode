class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_dishes, dependent: :destroy
  has_many :dishes, through: :menu_dishes
  has_many :menu_drinks, dependent: :destroy
  has_many :drinks, through: :menu_drinks

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }
end
