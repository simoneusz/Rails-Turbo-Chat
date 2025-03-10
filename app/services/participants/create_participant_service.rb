# frozen_string_literal: true

module Participants
  class CreateParticipantService < ApplicationService
    CODE_PARTICIPANT_INVALID = :participant_creation_failed
    CODE_PARTICIPANT_ALREADY_EXISTS = :participant_already_exists

    def initialize(room, user, role)
      super()
      @room = room
      @user = user
      @role = role
    end

    def call
      return error(code: CODE_PARTICIPANT_ALREADY_EXISTS) if @room.find_participant(@user).present?

      participant = @room.participants.new(user: @user, role: @role)
      return participant_invalid(participant) unless participant.save

      success(participant)
    rescue ActiveRecord::RecordInvalid, ArgumentError => e
      error(e.message, code: CODE_PARTICIPANT_INVALID)
    end

    private

    def participant_invalid(participant)
      error(participant.errors.full_messages.to_sentence, code: CODE_PARTICIPANT_INVALID)
    end
  end
end
