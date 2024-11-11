class Drink < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :image

  default_scope { where(deleted_at: nil) }

  has_many :portions, as: :portionable, dependent: :destroy
  has_many :menu_drinks
  has_many :menus, through: :menu_drinks
  has_many :order_items, dependent: :nullify

  validates :name, :description, :image, presence: true
  validates :image, content_type: { in: ['image/png', 'image/jpg', 'image/jpeg'], message: 'deve ser uma imagem do tipo PNG ou JPG' }
  validates :active, inclusion: { in: [true, false] }

  before_create :set_default_active

  def soft_delete
    update(deleted_at: Time.current)
  end

  private

  def set_default_active
    self.active = true if active.nil?
  end
end
