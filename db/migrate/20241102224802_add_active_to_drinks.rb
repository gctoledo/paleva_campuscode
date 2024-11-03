class AddActiveToDrinks < ActiveRecord::Migration[7.2]
  def change
    add_column :drinks, :active, :boolean, default: true
  end
end
