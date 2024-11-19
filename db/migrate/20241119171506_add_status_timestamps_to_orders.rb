class AddStatusTimestampsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :preparing_at, :datetime
    add_column :orders, :ready_at, :datetime
    add_column :orders, :delivered_at, :datetime
  end
end
