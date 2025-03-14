# frozen_string_literal: true

class User < ApplicationRecord
  after_create :create_self_room

  acts_as_reader

  mount_uploader :avatar, UserAvatarUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, presence: true, length: { minimum: 3, maximum: 20 }, uniqueness: true
  validates :email, presence: true, length: { minimum: 6, maximum: 255 }, uniqueness: true
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 20 }

  validates :username, uniqueness: true

  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }

  has_many :messages, dependent: :destroy
  has_many :sent_contacts, class_name: 'Contact', dependent: :destroy
  has_many :received_contacts,
           class_name: 'Contact',
           foreign_key: 'contact_id',
           dependent: :destroy,
           inverse_of: :contact
  has_many :participants, dependent: :destroy
  has_many :contacts, -> { where(contacts: { status: 1 }) }, through: :sent_contacts, source: :contact

  has_many :notifications, foreign_key: 'receiver_id', dependent: :destroy, inverse_of: :receiver
  has_many :sent_notifications, class_name: 'Notification',
                                foreign_key: 'sender_id',
                                dependent: :destroy,
                                inverse_of: :sender

  has_many :reactions, dependent: :destroy
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      assign_basic_info(user, auth)
      assign_username(user, auth)
      user.avatar_url = auth.info.image
    end
  end

  def self.assign_basic_info(user, auth)
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
  end

  def self.assign_username(user, auth)
    username = auth.info.name.downcase.delete(' ')
    username = user.email if User.exists?(username: username)
    user.username = username
  end

  def create_self_room
    room_params = { name: "#{username}_self_room", is_private: true }
    Rooms::CreatePeerRoomService.new(room_params, self, self).call
  end
end
