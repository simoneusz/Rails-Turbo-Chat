# frozen_string_literal: true

class Room < ApplicationRecord
  include Notificable

  belongs_to :creator, class_name: 'User'
  has_many :events, class_name: 'RoomEvent', dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :notifications, lambda {
    where(type: 'RoomNotification')
  }, class_name: 'RoomNotification', as: :item, dependent: :destroy, inverse_of: :item
  has_many :favorited, class_name: 'Favorite', dependent: :destroy

  enum :room_type, {
    public_room: 0,
    private_room: 1,
    peer_room: 2,
    self_room: 3
  }

  validates :name, uniqueness: true
  validates :name, presence: true

  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }

  scope :with_participant, lambda { |user|
    joins(:participants).where(participants: { user_id: user.id })
  }

  scope :with_role, lambda { |role|
    where(participants: { role: role })
  }

  scope :without_role, lambda { |role|
    where.not(participants: { role: role })
  }

  scope :ordered, -> { order(updated_at: :desc) }

  scope :all_group_for_user, lambda { |user|
    with_participant(user).without_role(:peer).ordered
  }

  scope :all_not_muted_groups_for_user, lambda { |user|
    with_participant(user)
      .without_role(:peer)
      .where(participants: { mute_notifications: false })
      .ordered
  }

  scope :all_peer_rooms_for_user, lambda { |user|
    with_participant(user).with_role(:peer).ordered
  }

  scope :all_private_rooms_for_user, lambda { |user|
    private_rooms
      .with_participant(user)
      .without_role(:peer)
      .ordered
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
    participants.find_by(user_id: user.id, role: :blocked).present?
  end

  def find_participant(user)
    return nil if user.nil?

    participants.find_by(user_id: user.id)
  end

  def peer_room?
    peers_size = participants.where(role: :peer).size
    peers_size == participants.size && peers_size == 2
  end

  def self_room?
    peers_size = participants.where(role: :peer).size
    peers_size == participants.size && peers_size == 1
  end
end
