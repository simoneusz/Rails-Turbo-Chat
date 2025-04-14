# frozen_string_literal: true

module Messages
  class MessageDestroyService < ApplicationService
    def initialize(message, room, user)
      @message = message
      @room = room
      @user = user
    end

    def call
      return error_cant_destroy_message unless @message.user == @user

      destroy_message

      success(nil)
    end

    private

    def destroy_message
      @message.destroy!
    end

    def error_cant_destroy_message
      error(code: CODE_USER_CANT_DESTROY_MESSAGE)
    end
  end
end
