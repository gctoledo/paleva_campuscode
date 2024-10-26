class Dish < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :image

  validates :name, :description, presence: true
  validates :image, content_type: { in: ['image/png', 'image/jpg', 'image/jpeg'], message: 'deve ser uma imagem do tipo PNG ou JPG' }
end
