class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :opentimes, dependent: :destroy
  accepts_nested_attributes_for :opentimes, allow_destroy: true


  validates :trade_name, :legal_name, :cnpj, :address, :phone, :email, presence: true

  validates :cnpj, :email, :legal_name, uniqueness: true

  validates :phone, format: { with: /\A\d{10,11}\z/, message: "deve ter 10 ou 11 dígitos" }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :cnpj_must_be_valid

  after_initialize :generate_unique_code, if: :new_record?

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
