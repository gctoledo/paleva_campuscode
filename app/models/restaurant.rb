class Restaurant < ApplicationRecord
  belongs_to :user

  validates :trade_name, :legal_name, :cnpj, :address, :phone, :email, presence: true
  
  validates :cnpj, :email, :legal_name, uniqueness: true
  validate :cnpj_must_be_valid

  before_create :generate_unique_code

  private

  def cnpj_must_be_valid
    errors.add(:cnpj, "não é válido") unless CNPJ.valid?(cnpj)
  end

  def generate_unique_code
    self.code = loop do
      random_code = SecureRandom.alphanumeric(6).upcase
      break random_code unless Restaurant.exists?(code: random_code)
    end
  end
end
