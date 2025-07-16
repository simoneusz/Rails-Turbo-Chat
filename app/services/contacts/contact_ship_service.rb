# frozen_string_literal: true

module Contacts
  class ContactShipService < ApplicationService
    def initialize(user, other_user)
      @user = user
      @other_user = other_user
    end

    def request_contact
      return error_add_self_to_contacts if self_contact?
      return accept_existing_request_and_succeed if incoming_pending_request?
      return error_contact_already_exists if existing_accepted_contact?

      upsert_outgoing_request

      notify_target_user(@other_user, @user, @other_user, :contact_invite_requested)
      success(@other_user)
    end

    def accept_contact
      contact_request = ContactShip.find_by(user: @other_user, contact: @user, status: :pending)
      return error_contact_doesnt_exist unless contact_request

      ActiveRecord::Base.transaction do
        contact_request.update!(status: :accepted)

        unless ContactShip.exists?(user: @user, contact: @other_user)
          ContactShip.create!(user: @user, contact: @other_user, status: :accepted)
        end
      end

      notify_target_user(@other_user, @user, @other_user, :contact_invite_accepted)
      success(@other_user)
    end

    def reject_contact
      contact_request = ContactShip.find_by(user: @other_user, contact: @user, status: :pending) ||
                        ContactShip.find_by(user: @user, contact: @other_user, status: :pending)

      return error_contact_doesnt_exist unless contact_request

      contact_request.update!(status: :rejected)
      notify_target_user(@other_user, @user, @other_user, :contact_invite_rejected)
      success(@other_user)
    end

    def delete_contact
      deleted = false

      ActiveRecord::Base.transaction do
        deleted |= ContactShip.where(user: @user, contact: @other_user).delete_all.positive?
        deleted |= ContactShip.where(user: @other_user, contact: @user).delete_all.positive?

        delete_peer_room
      end

      deleted ? success(@other_user) : error_contact_doesnt_exist
    end

    private

    def self_contact?
      @user == @other_user
    end

    def incoming_pending_request?
      @existing_request = ContactShip.find_by(user: @other_user, contact: @user, status: :pending)
    end

    def accept_existing_request_and_succeed
      accept_existing_request(@existing_request)
      success(@other_user)
    end

    def existing_accepted_contact?
      existing_contact = ContactShip.find_by(user: @user, contact: @other_user)
      existing_contact&.status_accepted?
    end

    def upsert_outgoing_request
      contact = ContactShip.find_by(user: @user, contact: @other_user)

      if contact&.status_rejected?
        contact.update!(status: :pending)
      elsif contact.nil?
        ContactShip.create!(user: @user, contact: @other_user, status: :pending)
      end
    end

    def accept_existing_request(request)
      ActiveRecord::Base.transaction do
        request.update!(status: :accepted)

        unless ContactShip.exists?(user: @user, contact: @other_user)
          ContactShip.create!(user: @user, contact: @other_user, status: :accepted)
        end
      end
      notify_target_user(@other_user, @user, @other_user, :contact_invite_accepted)
    end

    def delete_peer_room
      Room.peer_room_for_users(@user, @other_user).destroy_all
    end

    def error_add_self_to_contacts
      error(code: CODE_ADD_SELF_TO_CONTACTS)
    end

    def error_contact_already_exists
      error(code: CODE_CONTACT_ALREADY_EXISTS)
    end

    def error_contact_doesnt_exist
      error(code: CODE_CONTACT_DOESNT_EXISTS)
    end
  end
end
