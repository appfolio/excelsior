class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.text :name, null: false
      t.text :email, null: false

      t.timestamps
    end
  end
end
