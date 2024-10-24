class Opentime < ApplicationRecord
  belongs_to :restaurant
  validates :week_day, :close, :open, presence: true
  validates :week_day, inclusion: { in: 0..6 }
  validates :week_day, uniqueness: { scope: :restaurant_id, message: "já foi cadastrado para esse restaurante" }
  validate :validate_time

  private

  def validate_time
    if open.present? && close.present? && open >= close
      errors.add(:close, "deve ser maior que o horário de abertura")
    end
  end
end
