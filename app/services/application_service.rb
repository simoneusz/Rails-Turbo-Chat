# frozen_string_literal: true

class ApplicationService
  include Constants::ErrorCodes

  def notify_target_user(item, sender, receiver, notification_type, mute_notifications: false)
    return false if receiver == sender || mute_notifications

    UserNotification.create!(item:, sender:, receiver:, notification_type:)
  end

  def notify_room(room, sender, receiver, notification_type)
    RoomNotification.create!(item: room, sender:, receiver:, notification_type:)
  end

  protected

  def success(data = nil)
    Result.new(true, data: data)
  end

  def error(data = nil, code: nil)
    Result.new(false, data: data, error_code: code)
  end
end
