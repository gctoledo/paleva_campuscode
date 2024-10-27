class CreateDrinks < ActiveRecord::Migration[7.2]
  def change
    create_table :drinks do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :alcoholic, null: false, default: false
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
