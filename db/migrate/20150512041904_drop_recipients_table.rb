class DropRecipientsTable < ActiveRecord::Migration
  def up
    drop_table :recipients
  end

  def down

  end
end
