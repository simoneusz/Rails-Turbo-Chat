# frozen_string_literal: true

module Users
  class UpdateService < ApplicationService
    def initialize(user_id, user_params)
      @user_id = user_id
      @user_params = user_params
    end

    def call
      @user = find_user
      return error_user_not_found unless @user

      return error_update unless @user.update(@user_params)

      success(@user)
    end

    private

    def find_user
      User.find_by(id: @user_id)
    end

    def error_user_not_found
      error(code: CODE_USER_NOT_FOUND)
    end

    def error_update
      error(@user.errors.full_messages)
    end
  end
end
