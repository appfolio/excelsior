class CreateLikes < ActiveRecord::Migration
  def change
    create_join_table :messages, :users, table_name: :likes do |t|
      t.index :message_id
      t.index :user_id
      t.timestamps null:false
    end

    add_foreign_key :likes, :users
    add_foreign_key :likes, :messages
    add_index :likes, [:message_id, :user_id], unique: true
  end
end
