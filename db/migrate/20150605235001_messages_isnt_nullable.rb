class MessagesIsntNullable < ActiveRecord::Migration
  def up
    change_column :messages, :message, :text, null: false
  end

  def down
    change_column :messages, :message, :text
  end
end
