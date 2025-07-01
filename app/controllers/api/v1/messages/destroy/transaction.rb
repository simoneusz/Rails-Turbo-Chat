# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Destroy
        # Orchestrates message#destroy action
        class Transaction
          include ::TransactionResponse
          # Orchestrates message#destroy action
          #
          # @param message_id [Integer] message id
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(message_id, current_user)
            message = current_user.messages.find(message_id)

            Authorizer.new.call(message, current_user)
            Validator.new.call

            message.destroy

            response(status: :no_content)
          end
        end
      end
    end
  end
end
