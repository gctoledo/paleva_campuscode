class Drink < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :image
  has_many :portions, as: :portionable
  has_many :menu_drinks, dependent: :destroy
  has_many :menus, through: :menu_drinks

  validates :name, :description, :image, presence: true
  validates :image, content_type: { in: ['image/png', 'image/jpg', 'image/jpeg'], message: 'deve ser uma imagem do tipo PNG ou JPG' }
  validates :active, inclusion: { in: [true, false] }

  before_create :set_default_active

  private

  def set_default_active
    self.active = true if active.nil?
  end
end
