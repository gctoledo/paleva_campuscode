class CreateDishesTags < ActiveRecord::Migration[7.2]
  def change
    create_table :dishes_tags do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
