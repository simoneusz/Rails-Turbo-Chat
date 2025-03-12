# frozen_string_literal: true

class Message < ApplicationRecord
  acts_as_readable on: :created_at

  belongs_to :user, optional: true
  belongs_to :room
  has_rich_text :content

  after_create_commit { broadcast_append_to room }
  before_create :confirm_participant

  def next
    room = Room.find(self.room.id)
    room.messages.where('id > ?', id).first
  end

  def prev
    room = Room.find(self.room.id)
    room.messages.where(id: ...id).last
  end

  def confirm_participant
    return unless room.is_private

    is_participant = Participant.where(user_id: user.id, room_id: room.id).first
    throw :abort unless is_participant
  end
end
