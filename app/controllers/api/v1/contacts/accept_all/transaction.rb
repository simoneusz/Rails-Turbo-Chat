# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module AcceptAll
        # Orchestrates contact#accept_all action
        class Transaction
          include ::TransactionResponse

          # Orchestrates contact#accept_all action. Accepts all pending contacts for the user
          #
          # @param user [User] user instance
          # @return [Hash] transaction response with status, data, message
          def call(user)
            Authorizer.new.call
            Validator.new.call

            accept_all_contacts(user)

            response(status: :ok, data: nil, message: 'Accepted')
          end

          private

          # @param user [User] user instance
          # @param other_user [User] other user instance
          # @return [Contact] contact record
          def contact_record(user, other_user)
            Contact.find_by(user: other_user, contact: user, status: :pending) ||
              Contact.find_by(user: user, contact: other_user, status: :pending)
          end

          # @param user [User] user instance
          # @return [void]
          def accept_all_contacts(user)
            pending_contacts = user.pending_contacts
            return unless pending_contacts.any?

            pending_contacts.each do |contact|
              ::Contacts::ContactShipService.new(user, contact.user).accept_contact
            end
          end
        end
      end
    end
  end
end
