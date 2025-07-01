# frozen_string_literal: true

module Api
  module V1
    module Notifications
      module MarkAsRead
        # Orchestrates notification#mark_as_read action
        class Transaction
          include ::TransactionResponse
          # Orchestrates notification#mark_as_read action
          #
          # @param current_user [User] current logged user
          # @param notification [Notification] notification instance
          # @return [Hash] transaction response with status, data, message
          def call(current_user, notification)
            Authorizer.new.call(current_user, notification)
            Validator.new.call

            result = ::Notifications::MarkAsReadService.new(notification, current_user).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :ok, data: Serializer.new.call(result.data), message: 'Role changed')
          end
        end
      end
    end
  end
end
