# frozen_string_literal: true

module Participants
  class AddParticipantService < ApplicationService
    CODE_PARTICIPANT_INVALID = :new_participant_invalid

    def initialize(room, current_user, target_user, role)
      super()
      @room = room
      @current_user = current_user
      @target_user = target_user
      @role = role
    end

    def call
      result = create_participant
      if result&.success?
        success(result.data)
      else
        error(code: result.error_code || CODE_PARTICIPANT_INVALID)
      end
    end

    private

    def create_participant
      Participants::CreateParticipantService.new(@room, @target_user, @role).call
    end
    # def notify_users
    #   UserJoinedNotifier.with(user: @target_user, room: @room).deliver_later
    # end
  end
end
