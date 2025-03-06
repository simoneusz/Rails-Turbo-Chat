# frozen_string_literal: true

class RoomNotification < ApplicationRecord
  belongs_to :room

  validates :message, presence: true
end
