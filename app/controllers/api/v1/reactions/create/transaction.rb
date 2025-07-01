# frozen_string_literal: true

module Api
  module V1
    module Reactions
      module Create
        # Orchestrates reaction#create action
        class Transaction
          include ::TransactionResponse
          # Orchestrates reaction#create action
          #
          # @param params [ActionController::Parameters] params for create reaction
          # @param room [Room] room instance
          # @param message [Message] message instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(params, room, message, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call(params)

            result = ::Messages::ReactionsService.new(message, current_user, params[:emoji]).create

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :created, data: Serializer.new.call(result.data), message: 'Created')
          end
        end
      end
    end
  end
end
