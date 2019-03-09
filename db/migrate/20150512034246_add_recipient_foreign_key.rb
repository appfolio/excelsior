class AddRecipientForeignKey < ActiveRecord::Migration
  def up
    execute 'truncate table appreciations'
    add_foreign_key :appreciations, :users, column: 'recipient_id', foreign_key: 'users_id'
  end

  def down
    execute 'truncate table appreciations'
    remove_foreign_key :appreciations, :recipient
  end
end
