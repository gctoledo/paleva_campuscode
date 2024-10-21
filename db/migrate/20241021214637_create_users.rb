class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :cpf, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password, null: false

      t.timestamps
    end

    add_index :users, :cpf, unique: true
    add_index :users, :email, unique: true
  end
end
