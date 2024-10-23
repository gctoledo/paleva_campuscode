class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :trade_name, null: false
      t.string :legal_name, null: false
      t.string :cnpj, null: false
      t.string :address, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :code, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :restaurants, :cnpj, unique: true
    add_index :restaurants, :code, unique: true
    add_index :restaurants, :email, unique: true
    add_index :restaurants, :legal_name, unique: true
  end
end
