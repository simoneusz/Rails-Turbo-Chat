# frozen_string_literal: true

class ApplicationService
  include Constants::ErrorCodes

  def notify_target_user(target_user, notification_type, item, sender, mute_notifications: false)
    return false if target_user == sender || mute_notifications

    target_user.notifications.create(notification_type:, item:, sender:)
  end

  protected

  def success(data = nil)
    Result.new(true, data: data)
  end

  def error(data = nil, code: nil)
    Result.new(false, data: data, error_code: code)
  end
end
