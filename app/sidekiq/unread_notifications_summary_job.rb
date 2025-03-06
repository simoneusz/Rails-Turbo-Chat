# frozen_string_literal: true

require 'sidekiq-scheduler'

class UnreadNotificationsSummaryJob
  include Sidekiq::Job

  def perform(*_args)
    User.find_each do |user|
      next if user.unviewed_notifications_size.zero?
      next if user.notifications.last.notification_type == 'unread_notifications'

      user.notifications.create(notification_type: 'unread_notifications', item: user, sender: user)
    end
  end
end
