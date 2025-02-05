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

  def outgoing_contacts
    Contact.where(user_id: id, status: :pending)
  end

  def request_contact(other_user)
    return false if other_user == self

    existing_request = Contact.find_by(user: other_user, contact: self, status: :pending)

    if existing_request
      accept_contact(other_user)
      return true
    end

    contact = Contact.find_by(user: self, contact: other_user)

    if contact
      return false if contact.accepted?

      contact.update!(status: :pending) if contact.rejected?
    else
      Contact.create!(user: self, contact: other_user, status: :pending)
    end
  end

  def accept_contact(other_user)
    contact_request = received_contacts.find_by(user: other_user, status: :pending)

    return unless contact_request

    ActiveRecord::Base.transaction do
      contact_request.update!(status: :accepted)

      unless Contact.exists?(user: self, contact: other_user)
        Contact.create!(user: self, contact: other_user, status: :accepted)
      end
    end
  end

  def delete_contact(other_user)
    contact_request = received_contacts.find_by(user: other_user)

    return unless contact_request

    contact_request.destroy
  end

  def reject_contact(other_user)
    contact_request = other_user.received_contacts.find_by(user: self, status: :pending)
    contact_request&.update(status: :rejected)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
