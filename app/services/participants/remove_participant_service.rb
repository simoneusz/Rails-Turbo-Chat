module Participants
  class RemoveParticipantService
    def initialize(room, user)
      @room = room
      @user = user
    end

    def call
      participant = @room.find_participant(@user)

      return false unless participant

      @room.participants.delete(participant)

      true
    end
  end
end
