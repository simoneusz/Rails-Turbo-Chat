class Room < ApplicationRecord
  validates_uniqueness_of :name
  validates :name, presence: true
  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :notifications_mentions, as: :record, dependent: :destroy, class_name: 'Noticed::Event'
  # after_create_commit { broadcast_if_public }
  #
  # def broadcast_if_public
  #   broadcast_append_to 'rooms' unless is_private
  # end

  scope :for_user, lambda { |user|
    private_rooms.joins(:participants).where(participants: { user_id: user })
  }

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id, role: :peer)
    end
    single_room
  end

  def add_participant(sender, recipient, role)
    Participant.create(user_id: recipient.id, room_id: id, role: role)
    InviteReceivedNotifier.with(inviter: sender, room: self).deliver_later(recipient) unless sender == recipient
  end

  def remove_participant(sender, participant)
    participant.destroy
    recipient = participant.user
    InviteReceivedNotifier.with(inviter: sender, room: self).deliver_later(recipient) unless sender == recipient
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

  # def self.for_user(user)
  #   private_rooms.joins(:participants).where(participants: { user_id: user })
  # end
end
