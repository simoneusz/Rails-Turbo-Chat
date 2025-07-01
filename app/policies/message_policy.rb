# frozen_string_literal: true

class MessagePolicy < ApplicationPolicy
  def create?
    user.present? && record.room.participant?(user)
  end

  def destroy?
    record.user == user
  end
end
