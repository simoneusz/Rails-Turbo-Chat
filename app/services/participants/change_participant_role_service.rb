# frozen_string_literal: true

module Participants
  class ChangeParticipantRoleService < ApplicationService
    def initialize(participant, new_role)
      super()
      @participant = participant
      @new_role = new_role
    end

    def call
      return error_invalid_participant unless @participant
      return error_unknown_role unless Participant.roles.include?(@new_role)

      update_participant_role
      notify_room

      success(@participant)
    end

    private

    def update_participant_role
      @participant.update(role: @new_role)
    end

    def notify_room
      case @new_role
      when :blocked
        @participant.room
                    .notifications.create!(message: "#{@participant.user.username}' was blocked")
      else
        @participant.room
                    .notifications.create!(message: "#{@participant.user.username}'s role was changed to #{@new_role}")
      end
    end

    def error_invalid_participant
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end

    def error_unknown_role
      error(code: CODE_UNKNOWN_ROLE)
    end
  end
end
