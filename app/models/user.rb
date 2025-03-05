class User < ApplicationRecord
  acts_as_reader

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

  has_many :notifications, foreign_key: 'receiver_id', dependent: :destroy
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
    Contacts::ContactService.new(self, other_user).request_contact
  end

  def accept_contact(other_user)
    Contacts::ContactService.new(self, other_user).accept_contact
  end

  def delete_contact(other_user)
    Contacts::ContactService.new(self, other_user).delete_contact
  end

  def reject_contact(other_user)
    Contacts::ContactService.new(self, other_user).reject_contact
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
