# frozen_string_literal: true

class Message < ApplicationRecord
  acts_as_readable on: :created_at

  belongs_to :user, optional: true
  belongs_to :room
  has_one :room_event, as: :eventable, dependent: :destroy
  has_rich_text :content
  belongs_to :parent_message, class_name: 'Message', optional: true
  has_many :replies, class_name: 'Message', foreign_key: :parent_message_id, dependent: :nullify,
                     inverse_of: :parent_message
  has_many :reactions, dependent: :destroy

  after_create_commit { broadcast_append_to room }
  after_create_commit :create_room_event

  before_create :confirm_participant

  validates :content, presence: true, exclusion: [nil, '', ' ']

  def next
    room = Room.find(self.room.id)
    room.messages.where('id > ?', id).first
  end

  def prev
    room = Room.find(self.room.id)
    room.messages.where(id: ...id).last
  end

  def any_reactions_from_user?(user)
    reactions.exists?(user: user)
  end

  def reaction_counter
    reactions.group(:emoji).count
  end

  def reaction_by_emoji(emoji)
    reactions.find_by(emoji: emoji)
  end

  private

  def confirm_participant
    return unless room.is_private

    is_participant = Participant.where(user_id: user.id, room_id: room.id).first
    throw :abort unless is_participant
  end

  def create_room_event
    RoomEvent.create!(room:, eventable: self)
  end
end
