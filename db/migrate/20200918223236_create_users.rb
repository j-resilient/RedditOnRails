class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.integer :session_token, null: false
      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :session_token, unique: true
  end
end
