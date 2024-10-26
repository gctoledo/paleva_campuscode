class CreateDishes < ActiveRecord::Migration[7.2]
  def change
    create_table :dishes do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :calories
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
