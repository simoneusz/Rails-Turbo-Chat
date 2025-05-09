# frozen_string_literal: true

module Messages
  class CreationService < ApplicationService
    def initialize(message_params, room, user)
      @message_params = message_params
      @room = room
      @user = user
    end

    def call
      return error_invalid_participant unless @room.participant?(@user)

      @message = create_message
      return error_creation unless @message.valid?

      define_replied
      read_for_user
      touch_every_favorite

      success(@message)
    end

    private

    def touch_every_favorite
      Favorite.where(room_id: @room.id).find_each(&:touch)
    end

    def create_message
      @message = @user.messages.create(@message_params.merge(room: @room))
    end

    def define_replied
      @message.update!(replied: true) if @message.parent_message_id
    end

    def read_for_user
      @message.mark_as_read! for: @user
    end

    def error_creation
      error(@message.errors.full_messages)
    end

    def error_invalid_participant
      error(code: CODE_PARTICIPANT_DOESNT_EXIST)
    end
  end
end
