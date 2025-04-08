# frozen_string_literal: true

class RoomNotification < Notification
  has_one :room_event, as: :eventable, dependent: :destroy

  after_create_commit { broadcast_append_to item }
  after_create :create_room_event

  private

  def create_room_event
    RoomEvent.create!(room: item, eventable: self)
  end
end
