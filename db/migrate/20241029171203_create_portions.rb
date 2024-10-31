class CreatePortions < ActiveRecord::Migration[7.2]
  def change
    create_table :portions do |t|
      t.string :description, null: false
      t.decimal :price, null: false
      t.references :portionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
