class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, length: { minimum: 3, maximum: 20 }, uniqueness: true
  validates :email, presence: true, length: { minimum: 6, maximum: 255 }, uniqueness: true
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 20 }

  validates_uniqueness_of :username

  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }

  has_many :messages
  has_many :sent_contacts, class_name: 'Contact', foreign_key: 'user_id', dependent: :destroy
  has_many :received_contacts, class_name: 'Contact', foreign_key: 'contact_id', dependent: :destroy

  has_many :contacts, -> { where(contacts: { status: 1 }) }, through: :sent_contacts, source: :contact

  has_many :notifications
  def unviewed_notifications_size
    notifications.unviewed.size
  end

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
    received_contacts.find_by(user: other_user)&.destroy
    sent_contacts.find_by(contact: other_user)&.destroy
  end

  def reject_contact(other_user)
    contact_request = received_contacts.find_by(user: other_user, status: :pending) ||
                      sent_contacts.find_by(contact: other_user, status: :pending)
    contact_request&.update(status: :rejected)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[username email first_name last_name created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
