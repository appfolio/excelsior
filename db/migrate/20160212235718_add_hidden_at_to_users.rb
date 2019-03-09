class AddHiddenAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hidden_at, :datetime
  end
end
