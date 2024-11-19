class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_dishes, dependent: :destroy
  has_many :dishes, through: :menu_dishes
  has_many :menu_drinks, dependent: :destroy
  has_many :drinks, through: :menu_drinks

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }
  validates :start_date, presence: true, if: -> { end_date.present? }
  validates :end_date, presence: true, if: -> { start_date.present? }
  validate :validate_date

  private

  def validate_date
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "não pode ser anterior à data atual")
    end

    if end_date.present? && end_date < Date.today
      errors.add(:end_date, "não pode ser anterior à data atual")
    end

    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:end_date, "deve ser posterior à data de início")
    end
  end
end
