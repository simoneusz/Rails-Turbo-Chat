class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 20 }

  validates_uniqueness_of :username

  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }

  has_many :messages
  has_many :sent_contacts, class_name: 'Contact', foreign_key: 'user_id', dependent: :destroy
  has_many :received_contacts, class_name: 'Contact', foreign_key: 'contact_id', dependent: :destroy

  has_many :contacts, -> { where(contacts: { status: 1 }) }, through: :sent_contacts, source: :contact

  def pending_contacts
    received_contacts.where(status: :pending)
  end

  def request_contact(other_user)
    return if other_user == self || Contact.exists?(user: self, contact: other_user)

    Contact.create(user: self, contact: other_user, status: :pending)
  end

  def accept_contact(other_user)
    contact_request = received_contacts.find_by(user: other_user, status: :pending)
    contact_request&.update(status: :accepted)
  end

  def reject_contact(other_user)
    contact_request = received_contacts.find_by(user: other_user, status: :pending)
    contact_request&.update(status: :rejected)
  end
end
