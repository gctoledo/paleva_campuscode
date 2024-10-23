class CreateOpentimes < ActiveRecord::Migration[7.2]
  def change
    create_table :opentimes do |t|
      t.integer :week_day, null: false
      t.time :open
      t.time :close
      t.boolean :closed, default: false
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
