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
end
