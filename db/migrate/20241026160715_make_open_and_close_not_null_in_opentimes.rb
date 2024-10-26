class MakeOpenAndCloseNotNullInOpentimes < ActiveRecord::Migration[7.2]
  def change
    change_column_null :opentimes, :open, false
    change_column_null :opentimes, :close, false
  end
end