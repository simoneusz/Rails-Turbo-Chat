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
        notify_target_user unless @current_user == @target_user
        success(result.data)
      else
        error(code: result.error_code || CODE_PARTICIPANT_INVALID)
      end
    end

    private

    def create_participant
      Participants::CreateParticipantService.new(@room, @target_user, @role).call
    end

    def notify_target_user
      @target_user.notifications.create(notification_type: 'room_invite_received', item: @room, sender: @current_user)
    end

    def mark_every_message_as_read
      @room.messages.each do |message|
        message.mark_as_read! for: @target_user
      end
    end
  end
end
