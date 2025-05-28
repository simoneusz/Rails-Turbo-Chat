# frozen_string_literal: true

class UserNotificationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def mark_as_read?
    user.present? && record.receiver_id == user.id
  end
end
