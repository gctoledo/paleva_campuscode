class Portion < ApplicationRecord
  belongs_to :portionable, polymorphic: true
  has_many :price_histories, class_name: "PortionPriceHistory", dependent: :destroy

  before_update :store_price_history

  private

  def store_price_history
    if price_changed?
      price_histories.create(price: price_was, changed_at: Time.current)
    end
  end
end