class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :cpf_must_be_valid

  has_one :restaurant, dependent: :destroy

  private

  def cpf_must_be_valid
    errors.add(:cpf, "é inválido") unless CPF.valid?(cpf)
  end
end
