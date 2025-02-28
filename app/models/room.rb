class Room < ApplicationRecord
  validates_uniqueness_of :name
  validates :name, presence: true
  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :notifications_mentions, as: :record, dependent: :destroy, class_name: 'Noticed::Event'

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
  }

  scope :all_peer_rooms_for_user, lambda { |user|
    joins(:participants)
      .where(participants: { user_id: user.id, role: :peer })
  }

  scope :all_private_rooms_for_user, lambda { |user|
    private_rooms
      .joins(:participants)
      .where(participants: { user_id: user.id })
      .where.not(participants: { role: :peer })
  }

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id, role: :peer)
    end
    single_room
  end

  def url
    Rails.application.routes.url_helpers.product_url(self)
  end
  # def send_invitation(sender, recipient)
  #   InviteReceivedNotifier.with(inviter: sender, room: self).deliver_later(recipient)
  # end

  def participant?(user)
    participants.find_by(user_id: user.id).present?
  end

  def find_participant(user)
    return [] if user.nil?

    participants.find_by(user_id: user.id)
  end

  def peer_room?
    participants.where(role: :peer).size == 2
  end
end
