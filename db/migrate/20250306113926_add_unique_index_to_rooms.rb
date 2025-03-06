class AddUniqueIndexToRooms < ActiveRecord::Migration[7.1]
  def change
    add_index :rooms, :name, unique: true
  end
end
