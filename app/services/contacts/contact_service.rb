# frozen_string_literal: true

module Contacts
  class ContactService < ApplicationService
    def initialize(user, other_user)
      super()
      @user = user
      @other_user = other_user
    end

    def request_contact
      return error_add_self_to_contacts if @user == @other_user

      result_existing_request = existing_request
      return result_existing_request if result_existing_request

      contact = Contact.find_by(user: @user, contact: @other_user)
      return error_contact_already_exists if contact&.status_accepted?

      update_or_create_request_contact(contact)
      notify_target_user(@other_user, @user, @other_user, :contact_invite_requested)
      success(@other_user)
    end

    def update_or_create_request_contact(contact)
      if contact
        contact.update!(status: :pending) if contact.status_rejected?
      else
        Contact.create!(user: @user, contact: @other_user, status: :pending)
      end
    end

    def accept_contact
      contact_request = @user.received_contacts.find_by(user: @other_user, status: :pending)
      return error_contact_doesnt_exist unless contact_request

      ActiveRecord::Base.transaction do
        contact_request.update!(status: :accepted)

        unless Contact.exists?(user: @user, contact: @other_user)
          Contact.create!(user: @user, contact: @other_user, status: :accepted)
        end
      end
      notify_target_user(@other_user, @user, @other_user, :contact_invite_accepted)
      success(@other_user)
    end

    def delete_contact
      contact = @user.received_contacts.find_by(user: @other_user)
      return error_contact_doesnt_exist unless contact

      delete_peer_room

      @user.received_contacts.find_by(user: @other_user)&.destroy
      @user.sent_contacts.find_by(contact: @other_user)&.destroy

      success(@other_user)
    end

    def reject_contact
      contact_request = @user.received_contacts.find_by(user: @other_user, status: :pending) ||
                        @user.sent_contacts.find_by(contact: @other_user, status: :pending)

      return error_contact_doesnt_exist unless contact_request

      contact_request.update!(status: :rejected)
      notify_target_user(@other_user, @user, @other_user, :contact_invite_rejected)
      success(@other_user)
    end

    private

    def existing_request
      existing_request = Contact.find_by(user: @other_user, contact: @user, status: :pending)

      if existing_request
        accept_contact
        return success(@other_user)
      end

      false
    end

    def delete_peer_room
      Room.peer_room_for_users(@user, @other_user).destroy_all
    end

    def error_add_self_to_contacts
      error(code: CODE_ADD_SELF_TO_CONTACTS)
    end

    def error_contact_invalid
      error(code: CODE_CONTACT_INVALID)
    end

    def error_contact_already_exists
      error(code: CODE_CONTACT_ALREADY_EXISTS)
    end

    def error_contact_doesnt_exist
      error(code: CODE_CONTACT_DOESNT_EXISTS)
    end
  end
end
