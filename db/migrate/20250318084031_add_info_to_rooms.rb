class AddInfoToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :description, :string
    add_column :rooms, :topic, :string
    add_reference :rooms, :creator, foreign_key: { to_table: :users }
  end
end

Room.all.each do |room|
  room.update!(creator: room.participants.first.user)
end
