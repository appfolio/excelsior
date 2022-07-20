class DeleteAllFeedback < ActiveRecord::Migration[5.0]
  def up
    execute <<~SQL
      DELETE FROM messages WHERE "type" = 'Feedback';
    SQL
  end

  def down
    # no-op; hopefully you took a db backup
  end
end
