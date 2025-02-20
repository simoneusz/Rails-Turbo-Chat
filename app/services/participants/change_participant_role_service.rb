# frozen_string_literal: true

module Participants
  class ChangeParticipantRoleService < ApplicationService
    CODE_UNKNOWN_ROLE = :unknown_role

    def initialize(participant, new_role)
      super()
      @participant = participant
      @new_role = new_role
    end

    def call
      return error_invalid_participant unless @participant
      return error_unknown_role unless Participant.roles.include?(role)

      update_participant_role

      success(@participant)
    end
  end

  private

  def update_participant_role
    @participant.update(role: @new_role)
  end

  def error_invalid_participant
    error(code: CODE_PARTICIPANT_DOESNT_EXIST)
  end

  def error_unknown_role
    error(code: CODE_UNKNOWN_ROLE)
  end
end
