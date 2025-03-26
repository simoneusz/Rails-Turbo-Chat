# frozen_string_literal: true

class RoomNotification < ApplicationRecord
  belongs_to :room
  has_one :room_event, as: :eventable, dependent: :destroy

  validates :message, presence: true

  after_create_commit { broadcast_append_to room }
  after_create :create_room_event

  private

  def create_room_event
    RoomEvent.create!(room:, eventable: self)
  end
end
