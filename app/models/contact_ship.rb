# frozen_string_literal: true

class ContactShip < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: 'User'

  enum :status, { pending: 0, accepted: 1, rejected: 2 }, prefix: true

  validates :user_id, uniqueness: { scope: :contact_id }
end
