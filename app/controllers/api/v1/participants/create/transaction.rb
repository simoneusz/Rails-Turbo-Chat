# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Create
        # Orchestrates participant#create action
        class Transaction
          include ::TransactionResponse

          # @param params [ActionController::Parameters] params for creating a participant
          # @param room [Room] room instance
          # @param user [User] user instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(params, room, user, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call(params)

            result = ::Participants::AddParticipantService.new(room, current_user, user, :member).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :created, data: Serializer.new.call(result.data), message: 'Created')
          end
        end
      end
    end
  end
end
