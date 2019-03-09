class CreateAppreciations < ActiveRecord::Migration
  def change
    create_table :appreciations do |t|
      t.text :appreciation
      t.string :submitter
      t.string :receiver
      t.string :type
      t.string :team

      t.timestamps
    end
  end
end
