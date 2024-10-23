class Opentime < ApplicationRecord
  belongs_to :restaurant

  validates :week_day, presence: true
  validate :validate_time

  private

  def validate_time
    if open.present? && close.present? && open >= close
      errors.add(:close, "deve ser maior que o horário de abertura")
    end
  end
end
