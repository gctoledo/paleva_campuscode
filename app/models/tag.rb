class Tag < ApplicationRecord
  belongs_to :restaurant
  has_many :dishes_tags, dependent: :destroy
  has_many :dishes, through: :dishes_tags

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }

  before_validation :capitalize_name
  
  private

  def capitalize_name
    self.name = name.capitalize if self.name
  end
end
