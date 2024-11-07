class AddDeletedAtToDishesAndDrinks < ActiveRecord::Migration[7.2]
  def change
    add_column :dishes, :deleted_at, :datetime
    add_column :drinks, :deleted_at, :datetime
  end
end
