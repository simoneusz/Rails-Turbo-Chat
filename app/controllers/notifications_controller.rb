# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
    @notifications.update(viewed: true)
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.update(viewed: true)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path }
    end
  end
end
