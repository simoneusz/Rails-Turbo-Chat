# frozen_string_literal: true

module Users
  class ChangeStatusService < ApplicationService
    def initialize(user_id, new_status)
      @user = User.find_by(id: user_id)
      @new_status = new_status
    end

    def call
      return user_not_found unless @user
      return status_invalid unless valid_status?

      if @user.update(status: @new_status)
        @user.update(status_changed: @new_status != 'online')
        success(@user)
      else
        error(@user.errors.full_messages, code: CODE_USER_UPDATE_FAILED)
      end
    end

    private

    def valid_status?
      User.statuses.keys.include?(@new_status)
    end

    def user_not_found
      error(code: CODE_USER_NOT_FOUND)
    end

    def status_invalid
      error(code: CODE_STATUS_INVALID)
    end
  end
end
