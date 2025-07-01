# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    (record.is_private ? record.participant?(user) : true) && !participant&.blocked?
  end

  def create?
    true
  end

  def update?
    user.present? && participant&.owner?
  end

  def destroy?
    update?
  end

  def join?
    !participant&.blocked? && !participant?
  end

  def leave?
    participant? && !(participant&.peer? || participant&.blocked?)
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

  private

  def participant
    record.find_participant(user)
  end

  def participant?
    record.find_participant(user).present?
  end
end
