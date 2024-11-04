class CreateTags < ActiveRecord::Migration[7.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end