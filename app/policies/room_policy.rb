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
    participant&.role == 'owner'
  end

  def moderator?
    participant&.role == 'moderator'
  end

  def member?
    participant&.role == 'member'
  end

  def peer?
    participant&.role == 'peer'
  end

  def user_role
    record.role[user.id]
  end
end
