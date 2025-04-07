# frozen_string_literal: true

module Participants
  class RemoveParticipantService < ApplicationService
    CODE_PARTICIPANT_DOESNT_EXIST = :participant_doesnt_exist

    def initialize(room, current_user, user)
      super()
      @room = room
      @current_user = current_user
      @user = user
    end

    def call
      participant = @room.find_participant(@user)
      return error_cant_find_participants unless participant

      remove_participant(participant)
      notify_room
      success(participant)
    end

    private

    def remove_participant(participant)
      @room.participants.delete(participant)
    end

    def notify_room
      @room.notifications.create!(message: "#{@current_user.username} kicked #{@user.username}")
    end

    def error_cant_find_participants
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end
  end
end
