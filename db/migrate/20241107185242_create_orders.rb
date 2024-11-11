class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :customer_name, null: false
      t.string :customer_cpf
      t.string :customer_email
      t.string :customer_phone
      t.references :restaurant, null: false, foreign_key: true
      t.string :code, null: false
      t.integer :status, default: 0, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
