class Order < ApplicationRecord
  belongs_to :restaurant

  has_many :order_items, dependent: :destroy

  enum :status, [:awaiting_confirmation, :preparing, :canceled, :ready, :delivered]

  after_initialize :generate_unique_code, if: :new_record?

  before_save :calculate_total

  before_update :set_status_timestamps, if: :will_save_change_to_status?

  validates :customer_name, presence: true
  validates :customer_phone, format: { with: /\A\d{10,11}\z/, message: "deve ter 10 ou 11 dígitos" }, presence: true, unless: -> { customer_email.present? }
  validates :customer_email, format: { with: /\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}\z/, message: "não é válido" }, presence: true, unless: -> { customer_phone.present? }

  validate :cpf_must_be_valid
  validate :must_have_at_least_one_item

  def add_order_item(portion:, dish: nil, drink: nil, note: nil)
    order_item = order_items.build(portion: portion, price: portion.price, dish: dish, drink: drink, note: note)
    calculate_total
    order_item
  end

  private

  def calculate_total
    self.total_price = order_items.sum { |h| h[:price] }
  end

  def cpf_must_be_valid
    return unless customer_cpf.present?
    
    errors.add(:customer_cpf, "não é válido") unless CPF.valid?(customer_cpf)
  end

  def must_have_at_least_one_item
    if order_items.empty?
      errors.add(:base, "Selecione pelo menos um prato ou uma bebida para o pedido.")
    end
  end

  def generate_unique_code
    self.code = loop do
      random_code = SecureRandom.alphanumeric(8).upcase
      break random_code unless Order.exists?(code: random_code)
    end
  end

  def set_status_timestamps
    case status
    when "preparing"
      self.preparing_at = Time.current
    when "ready"
      self.ready_at = Time.current
    when "delivered"
      self.delivered_at = Time.current
    end
  end
end
