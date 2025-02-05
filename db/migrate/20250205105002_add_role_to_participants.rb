class AddRoleToParticipants < ActiveRecord::Migration[7.1]
  def change
    add_column :participants, :role, :integer, default: 0
  end
end
