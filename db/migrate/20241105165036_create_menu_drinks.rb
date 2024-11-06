class CreateMenuDrinks < ActiveRecord::Migration[7.2]
  def change
    create_table :menu_drinks do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :drink, null: false, foreign_key: true

      t.timestamps
    end
  end
end
