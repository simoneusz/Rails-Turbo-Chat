# frozen_string_literal: true

module Rooms
  class JoinRoomService < ApplicationService
    def initialize(room, user)
      @room = room
      @user = user
      @joined_user_role = :member
    end

    def call
      return error(code: :cant_join_private_room) if @room.is_private

      result = create_participant
      if result&.success?
        notify_room(@room, @user, @user, 'join_room')
        success(result.data)
      else
        error(code: CODE_PARTICIPANT_INVALID)
      end
    end

    def create_participant
      Participants::CreateParticipantService.new(@room, @user, @joined_user_role).call
    end
  end
end
