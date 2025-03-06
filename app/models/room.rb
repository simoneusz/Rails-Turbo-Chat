# frozen_string_literal: true

class Room < ApplicationRecord
  include Notificable

  validates :name, uniqueness: true
  validates :name, presence: true
  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy

  scope :all_for_user, lambda { |user|
    left_outer_joins(:participants)
      .where(is_private: false)
      .or(where(participants: { user_id: user.id }))
      .distinct
  }

  scope :all_group_for_user, lambda { |user|
    joins(:participants)
      .where(participants: { user_id: user.id })
      .where.not(participants: { role: :peer })
      .order(:created_at)
  }

  scope :all_peer_rooms_for_user, lambda { |user|
    joins(:participants)
      .where(participants: { user_id: user.id, role: :peer })
      .order(:created_at)
  }

  scope :all_private_rooms_for_user, lambda { |user|
    private_rooms
      .joins(:participants)
      .where(participants: { user_id: user.id })
      .where.not(participants: { role: :peer })
      .order(:created_at)
  }

  def user_ids
    participants.map(&:user_id)
  end

  def participant?(user)
    participants.find_by(user_id: user.id).present?
  end

  def user_blocked?(user)
    participants.where(user_id: user.id, role: :blocked).present?
  end

  def find_participant(user)
    return [] if user.nil?

    participants.find_by(user_id: user.id)
  end

  def peer_room?
    participants.where(role: :peer).size == 2
  end
end
