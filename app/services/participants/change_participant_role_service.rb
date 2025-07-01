# frozen_string_literal: true

module Participants
  class ChangeParticipantRoleService < ApplicationService
    def initialize(participant, new_role)
      @participant = participant
      @new_role = new_role
    end

    def call
      return error_invalid_participant unless @participant
      return error_unknown_role unless Participant.roles.include?(@new_role)
      return error_cant_change_role if @participant.owner?

      update_participant_role
      notify_participant_room

      success(@participant)
    end

    private

    def update_participant_role
      @participant.update(role: @new_role)
    end

    def notify_participant_room
      case @new_role
      when :blocked
        notify_room(@participant.room, @participant.user, @participant.user, 'participant_blocked')
      else
        notify_room(@participant.room, @participant.user, @participant.user, 'participant_role_changed')
      end
    end

    def error_invalid_participant
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end

    def error_cant_change_role
      error(code: CODE_CANT_CHANGE_ROLE)
    end

    def error_unknown_role
      error(code: CODE_UNKNOWN_ROLE)
    end
  end
end
