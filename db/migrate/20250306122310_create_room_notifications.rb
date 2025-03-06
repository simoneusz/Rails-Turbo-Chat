class CreateRoomNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :room_notifications do |t|
      t.references :room, null: false, foreign_key: true
      t.string :message

      t.timestamps
    end
  end
end
