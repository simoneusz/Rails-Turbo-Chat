# frozen_string_literal: true

# Class for user notifications
class Notification < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :user

  scope :unviewed, -> { where(viewed: false) }
  default_scope { latest }

  after_create_commit do
    broadcast_prepend_to "broadcast_to_user_#{user_id}",
                         target: 'notifications',
                         partial: 'notifications/fixed_notification',
                         locals: { notification: self }
  end

  after_update_commit do
    broadcast_replace_to "broadcast_to_user_#{user_id}",
                         target: "notification_#{id}",
                         partial: 'notifications/fixed_notification',
                         locals: { notification: self }
  end

  after_destroy_commit do
    broadcast_remove_to "broadcast_to_user_#{user_id}",
                        target: "notification_#{id}"
  end

  after_commit do
    broadcast_replace_to "broadcast_to_user_#{user_id}",
                         target: 'notifications_count',
                         partial: 'notifications/count',
                         locals: { count: user.notifications.unviewed.count }
  end
end
