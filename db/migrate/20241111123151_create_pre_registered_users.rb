class CreatePreRegisteredUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :pre_registered_users do |t|
      t.string :email, null: false
      t.string :cpf, null: false
      t.references :restaurant, null: false, foreign_key: true
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
