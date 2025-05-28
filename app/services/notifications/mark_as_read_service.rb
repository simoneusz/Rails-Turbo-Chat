# frozen_string_literal: true

module Notifications
  class MarkAsReadService < ApplicationService
    def initialize(notification, user)
      @notification = notification
      @user = user
      Rails.logger.info("notification, user: #{@notification}, #{@user}")
    end

    def call
      return unauthorized unless @notification.receiver_id == @user.id

      @notification.update(viewed: true)
      success(@notification)
    end

    private

    def unauthorized
      error(code: CODE_UNAUTHORIZED_NOTIFICATION_ACCESS)
    end
  end
end
