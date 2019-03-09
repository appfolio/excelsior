class AddParentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :parent_id, :integer
    add_column :messages, :root_id, :integer

    add_foreign_key :messages, :messages, :column => :parent_id
    add_foreign_key :messages, :messages, :column => :root_id
  end
end
