class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :restaurant, optional: true
  validates :first_name, :last_name, :cpf, presence: true
  validates :cpf, :email, uniqueness: true
  validate :cpf_must_be_valid

  has_one :restaurant, dependent: :destroy

  enum :role, [:owner, :employee]
  after_initialize { self.role = 0 if self.role.nil? }

  def restaurant
    Restaurant.joins(:users).find_by(users: { id: id })
  end

  private

  def cpf_must_be_valid
    errors.add(:cpf, "é inválido") unless CPF.valid?(cpf)
  end
end
