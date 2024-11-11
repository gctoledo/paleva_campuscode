class PreRegisteredUser < ApplicationRecord
  belongs_to :restaurant

  validates :email, :cpf, presence: true

  validate :unique_email, if: -> { !used }
  validate :unique_cpf, if: -> { !used }
  validate :cpf_must_be_valid
  validates :email, format: { with: /\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}\z/, message: "não é válido" }

  private

  def unique_email
    if User.exists?(email: email) || PreRegisteredUser.exists?(email: email)
      errors.add(:email, "já está em uso")
    end
  end

  def unique_cpf
    if User.exists?(cpf: cpf) || PreRegisteredUser.exists?(cpf: cpf)
      errors.add(:cpf, "já está em uso")
    end
  end

  def cpf_must_be_valid
    errors.add(:cpf, "é inválido") unless CPF.valid?(cpf)
  end
end
