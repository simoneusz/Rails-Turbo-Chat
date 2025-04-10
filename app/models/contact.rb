# frozen_string_literal: true

class Contact < ApplicationRecord
  enum :status, { pending: 0, accepted: 1, rejected: 2 }, prefix: true

  belongs_to :user
  belongs_to :contact, class_name: 'User'

  validates :user_id, uniqueness: { scope: :contact_id }
end
