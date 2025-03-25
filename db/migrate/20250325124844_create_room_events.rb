class CreateRoomEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :room_events do |t|
      t.references :room, null: false, foreign_key: true
      t.references :eventable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
