# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Create
        # Orchestrates message#create action
        class Transaction
          include ::TransactionResponse
          # Orchestrates message#create action
          #
          # @param message_params [ActionController::Parameters] params for create message
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(message_params, room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call(message_params)

            result = ::Messages::CreationService.new(message_params, room, current_user).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :created, data: Serializer.new.call(result.data), message: 'Created')
          end
        end
      end
    end
  end
end
