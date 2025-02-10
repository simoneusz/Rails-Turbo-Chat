class RoomPolicy < ApplicationPolicy
  def assign_moderator?
    owner?
  end

  def invite_users?
    owner? || moderator? || member?
  end

  def kick_users?
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

  def user_role
    record.role[user.id]
  end
end
