# frozen_string_literal: true

module Users
  class OpenPrivateChatService < ApplicationService
    def initialize(current_user, target_user)
      super()
      @current_user = current_user
      @target_user = target_user
    end

    def call
      return error(code: CODE_USER_NOT_FOUND) unless @target_user

      room = Room.find_by(name: private_room_name)

      return success(room) if room

      result = Rooms::CreatePeerRoomService.new(
        { name: private_room_name, is_private: true },
        @current_user,
        @target_user
      ).call

      result.success? ? success(result.data) : error_from(result)
    end

    private

    def private_room_name
      [@current_user, @target_user].sort_by(&:id).then do |users|
        "private_#{users[0].id}_#{users[1].id}"
      end
    end

    def error_from(result)
      error(code: result.error_code)
    end
  end
end
