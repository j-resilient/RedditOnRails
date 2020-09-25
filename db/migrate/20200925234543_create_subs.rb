class CreateSubs < ActiveRecord::Migration[5.2]
  def change
    create_table :subs do |t|
      t.string :title, null: false
      t.text :description, null: false
    end
    add_index :subs, :title
  end
end
