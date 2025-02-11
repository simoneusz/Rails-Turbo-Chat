class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :room
  enum role: {
    member: 0,
    moderator: 1,
    owner: 2,
    peer: 3
  }
  validates :role, presence: true
end
