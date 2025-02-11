class RoomPolicy < ApplicationPolicy
  def assign_moderator?
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

  def chat?
    true
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
    record.participants.find_by(user_id: user.id)&.role
  end
end
