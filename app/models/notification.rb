# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :receiver, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  scope :unviewed, -> { where(viewed: false) }
  default_scope { latest }

  after_create_commit do
    broadcast_update_to "broadcast_to_user_#{receiver_id}",
                        target: 'notifications',
                        partial: 'notifications/fixed_notification',
                        locals: { notification: self }
  end

  after_update_commit do
    broadcast_replace_to "broadcast_to_user_#{receiver_id}",
                         target: "notification_#{id}",
                         partial: 'notifications/fixed_notification',
                         locals: { notification: self }
  end

  after_destroy_commit do
    broadcast_remove_to "broadcast_to_user_#{receiver_id}",
                        target: "notification_#{id}"
  end

  after_commit do
    broadcast_update_to "broadcast_to_user_#{receiver_id}",
                        target: 'notifications_count',
                        partial: 'notifications/count',
                        locals: { count: receiver.notifications.unviewed.count }
  end
end
