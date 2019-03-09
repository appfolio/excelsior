class ChangeSubmitterToRelation < ActiveRecord::Migration
  def up
    execute 'truncate table appreciations'
    remove_column :appreciations, :submitter
    add_column :appreciations, :submitter_id, :integer, null: false
    add_foreign_key :appreciations, :users, column: 'submitter_id', foreign_key: 'users_id'
  end

  def down
    execute 'truncate table appreciations'
    remove_foreign_key :appreciations, :submitter
    remove_column :appreciations, :submitter_id
    add_column :appreciations, :submitter, :string, null: false
  end
end
