# frozen_string_literal: true

module Participants
  class ToggleNotificationsService < ApplicationService
    def initialize(room, user)
      @room = room
      @user = user
    end

    def call
      @participant = @room.find_participant(@user)
      return error_cant_find_participants unless @participant

      toggle_notifications
      success(@participant)
    end

    private

    def toggle_notifications
      @participant.update(mute_notifications: !@participant.mute_notifications)
    end

    def error_cant_find_participants
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end
  end
end
