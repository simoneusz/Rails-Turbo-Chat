# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    !record.user_blocked?(user) && (record.is_private ? record.participant?(user) : true)
  end

  def create?
    true
  end

  def update?
    user.present? && record.find_participant(user)&.owner?
  end

  def destroy?
    update?
  end

  def join?
    !record.user_blocked?(user)
  end

  def leave?
    index?
  end

  def chat?
    index?
  end

  def all?
    index?
  end

  def dms?
    index?
  end
end
