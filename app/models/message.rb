# frozen_string_literal: true

class Message < ApplicationRecord
  acts_as_readable on: :created_at

  belongs_to :user, optional: true
  belongs_to :room, touch: true
  belongs_to :parent_message, class_name: 'Message', optional: true
  has_rich_text :content
  has_many :replies, class_name: 'Message', foreign_key: :parent_message_id, dependent: :nullify,
                     inverse_of: :parent_message
  has_many :reactions, dependent: :destroy
  has_one :room_event, as: :eventable, dependent: :destroy

  validates :content, presence: true, exclusion: [nil, '', ' ']

  after_create_commit { broadcast_append_to room }
  after_create_commit :create_room_event
  before_create :confirm_participant

  def next
    room.messages.where('id > ?', id).first
  end

  def prev
    room.messages.where(id: ...id).last
  end

  def any_reactions_from_user?(user)
    reactions.exists?(user: user)
  end

  def grouped_reactions
    reactions.includes(:user).group_by(&:emoji)
  end

  def sorted_grouped_reactions
    grouped_reactions.sort_by { |_, reactions| -reactions.size }.to_h
  end

  def reaction_by_emoji(emoji)
    reactions.find_by(emoji: emoji)
  end

  def reaction_by_user(user)
    reactions.find_by(user: user)
  end

  private

  def confirm_participant
    return unless room.is_private

    throw :abort unless room.participant?(user)
  end

  def create_room_event
    RoomEvent.create!(room:, eventable: self)
  end
end
