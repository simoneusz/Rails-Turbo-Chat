# frozen_string_literal: true

class Room < ApplicationRecord
  include Notificable

  validates :name, uniqueness: true
  validates :name, presence: true
  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }
  belongs_to :creator, class_name: 'User'
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :user_notifications, class_name: 'Notification', as: :item, dependent: :destroy
  has_many :notifications, class_name: 'RoomNotification', dependent: :destroy

  has_many :favorited, class_name: 'Favorite', dependent: :destroy

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

  scope :peer_room_for_users, lambda { |user, other_user|
    joins(:participants)
      .where(participants: { user_id: [user.id, other_user.id], role: :peer })
      .group('rooms.id')
      .having('COUNT(participants.id) = 2')
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
    peers_size = participants.where(role: :peer).size
    peers_size == participants.size && !peers_size&.zero?
  end
end
