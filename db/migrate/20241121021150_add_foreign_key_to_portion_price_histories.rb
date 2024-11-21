class AddForeignKeyToPortionPriceHistories < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :portion_price_histories, :portions, column: :portion_id, on_delete: :cascade    
  end
end
