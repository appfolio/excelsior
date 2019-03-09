class DropTypeColumn < ActiveRecord::Migration
  def up
    remove_column :appreciations, :type
  end
end
