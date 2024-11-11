class Portion < ApplicationRecord
  belongs_to :portionable, polymorphic: true
  has_many :price_histories, class_name: "PortionPriceHistory", dependent: :destroy
  has_many :order_items

  before_update :store_price_history

  validates :description, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate :price_must_have_two_decimal_places

  private

  def store_price_history
    if price_changed?
      price_histories.create(price: price_was, changed_at: Time.current)
    end
  end

  def price_must_have_two_decimal_places
    if price.present? && (price * 100) % 1 != 0
      errors.add(:price, "deve ter no máximo duas casas decimais.")
    end
  end
end