class RemoveParentId < ActiveRecord::Migration
  def up
    remove_column :messages, :parent_id
  end
end
