# frozen_string_literal: true

module Api
  module V1
    module Participants
      module ToggleNotifications
        # Orchestrates participant#change_role, #block, #unblock actions
        class Transaction
          include ::TransactionResponse

          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            result = ::Participants::ToggleNotificationsService.new(room, current_user).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :ok, data: Serializer.new.call(result.data), message: 'Notifications toggled')
          end
        end
      end
    end
  end
end
