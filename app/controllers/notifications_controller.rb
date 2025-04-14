# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
    @notifications.update(viewed: true)
  end

  def mark_as_read # rubocop:disable Metrics/MethodLength
    @notification = current_user.notifications.find(params[:id])
    result = Notifications::MarkAsReadService.new(@notification, current_user).call

    respond_to do |format|
      format.turbo_stream
      format.html do
        if result.success?
          redirect_to notifications_path
        else
          redirect_to notifications_path, alert: 'Could not mark notification as read'
        end
      end
    end
  end
end
