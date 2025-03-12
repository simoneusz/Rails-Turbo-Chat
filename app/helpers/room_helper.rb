# frozen_string_literal: true

module RoomHelper
  def peer_room_other_user_or_self(room)
    if room.participants.size > 1
      room.participants.where.not(user_id: current_user.id).first.user
    else
      current_user
    end
  end
end
