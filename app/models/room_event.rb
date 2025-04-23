# frozen_string_literal: true

class RoomEvent < ApplicationRecord
  belongs_to :room
  belongs_to :eventable, polymorphic: true

  validates :eventable_type, presence: true

  def next
    room.events.where('id > ?', id).first
  end

  def prev
    room.events.where(id: ...id).last
  end
end
