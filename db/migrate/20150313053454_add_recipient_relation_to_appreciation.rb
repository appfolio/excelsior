class AddRecipientRelationToAppreciation < ActiveRecord::Migration
  def up
    execute "delete from appreciations;"
    remove_column :appreciations, :receiver
    add_column :appreciations, :recipient_id, :integer, :null => false
  end

  def down
    execute "delete from appreciations;"
    add_column :appreciations, :receiver, :string, :null => false
    remove_column :appreciations, :recipient_id
  end
end
