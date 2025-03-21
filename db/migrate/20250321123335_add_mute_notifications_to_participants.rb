class AddMuteNotificationsToParticipants < ActiveRecord::Migration[7.1]
  def change
    add_column :participants, :mute_notifications, :boolean, default: false, null: false
  end
end
