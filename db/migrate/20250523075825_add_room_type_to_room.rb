class AddRoomTypeToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :room_type, :integer, default: 0
  end
end
