class AddRestaurantIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :restaurant_id, :integer
  end
end
