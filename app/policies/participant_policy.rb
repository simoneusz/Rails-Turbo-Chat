# frozen_string_literal: true

class ParticipantPolicy < ApplicationPolicy
  def change_role?
    owner? || moderator?
  end

  def block?
    change_role?
  end

  def unblock?
    change_role?
  end

  def chat?
    !blocked?
  end

  def join?
    !blocked?
  end

  def index?
    !blocked?
  end

  def show?
    !(non_participant? || blocked?)
  end

  def create?
    owner? || moderator? || member?
  end

  def new?
    !blocked?
  end

  def update?
    owner? || moderator?
  end

  def edit?
    owner?
  end

  def destroy?
    owner? || moderator?
  end

  def leave?
    !(peer? || blocked?)
  end

  def toggle_notifications?
    !blocked?
  end

  private

  def owner?
    user_role == 'owner'
  end

  def moderator?
    user_role == 'moderator'
  end

  def member?
    user_role == 'member'
  end

  def peer?
    user_role == 'peer'
  end

  def blocked?
    user_role == 'blocked'
  end

  def non_participant?
    user_role == 'non_participant'
  end

  def user_role
    record&.role || 'non_participant'
  end
end
