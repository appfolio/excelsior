class AddFieldsToAppreciations < ActiveRecord::Migration
  def change
    add_column :appreciations, :private, :boolean, default: false, null: false
    add_column :appreciations, :anonymous, :boolean, default: false, null: false
    add_column :appreciations, :type, :string
    add_column :appreciations, :received_at, :datetime

    rename_column :appreciations, :appreciation, :message
    rename_table :appreciations, :messages
  end
end
