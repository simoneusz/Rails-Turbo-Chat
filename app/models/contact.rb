class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: 'User'

  enum status: %i[pending accepted rejected], _prefix: true

  validates :user_id, uniqueness: { scope: :contact_id }
end
