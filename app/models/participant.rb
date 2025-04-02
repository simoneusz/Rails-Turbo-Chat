# frozen_string_literal: true

class Participant < ApplicationRecord
  enum :role, {
    member: 0,
    moderator: 1,
    owner: 2,
    peer: 3,
    blocked: 4
  }

  belongs_to :user
  belongs_to :room

  validates :role, presence: true

  scope :with_notifications_enabled, -> { where(mute_notifications: false) }

  after_create_commit :broadcast_user_rooms

  private

  def broadcast_user_rooms
    broadcast_update_to(
      "broadcast_to_user_#{user.id}",
      target: 'user_rooms',
      partial: 'layouts/sidebar/all_group_for_user', locals: { user: }
    )
  end
end
