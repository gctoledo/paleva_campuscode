class CreatePortionPriceHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :portion_price_histories do |t|
      t.decimal :price, null: false
      t.references :portion, null: false, foreign_key: true
      t.datetime :changed_at, null: false
    end
  end
end
