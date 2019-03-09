class SetDefaultValuesForMessages < ActiveRecord::Migration
  def up
    update "UPDATE messages SET received_at = created_at"
    update "UPDATE messages SET type = 'Appreciation'"
  end

  def down
  end
end
