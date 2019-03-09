class AddHiddenAtToAppreciations < ActiveRecord::Migration
  def change
    add_column :appreciations, :hidden_at, :datetime
  end
end
