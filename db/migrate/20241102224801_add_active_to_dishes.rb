class AddActiveToDishes < ActiveRecord::Migration[7.2]
  def change
    add_column :dishes, :active, :boolean, default: true
  end
end
