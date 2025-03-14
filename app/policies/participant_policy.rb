# frozen_string_literal: true

class ParticipantPolicy < ApplicationPolicy
  def change_role?
    owner?
  end

  def add_participant?
    owner? || moderator? || member?
  end

  def remove_participant?
    owner? || moderator?
  end

  def block_participant?
    owner? || moderator?
  end

  def unblock_participant?
    owner? || moderator?
  end

  def chat?
    !blocked?
  end

  def index?
    !blocked?
  end

  def show?
    !blocked?
  end

  def create?
    !blocked?
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
    owner?
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

  def user_role
    record&.role
  end
end
