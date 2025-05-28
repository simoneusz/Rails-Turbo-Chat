# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Accept
        # Orchestrates contact#accept action
        class Transaction
          include ::TransactionResponse

          # Orchestrates contact#accept action
          #
          # @param params [ActionController::Parameters] params for accept contact
          # @param user [User] user instance
          # @param other_user [User] other user instance
          # @return [Hash] transaction response with status, data, message
          def call(params, user, other_user)
            Authorizer.new.call
            Validator.new.call(params)

            result = ::Contacts::ContactService.new(user, other_user).accept_contact

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :ok, data: Serializer.new.call(contact_record(user, other_user)), message: 'Accepted')
          end

          private

          def contact_record(user, other_user)
            Contact.find_by(user: other_user, contact: user, status: :pending) ||
              Contact.find_by(user: user, contact: other_user, status: :pending)
          end
        end
      end
    end
  end
end
