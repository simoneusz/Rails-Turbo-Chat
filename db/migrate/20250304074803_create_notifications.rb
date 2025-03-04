class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :item, polymorphic: true, null: false
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :sender, foreign_key: { to_table: :users }
      t.boolean :viewed, null: false, default: false
      t.string :notification_type, null: false

      t.timestamps
    end
  end
end
