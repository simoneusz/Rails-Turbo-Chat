# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Destroy
        class Transaction
          include ::TransactionResponse

          def call(message_id, current_user)
            message = current_user.messages.find(message_id)

            Authorizer.new.call(message, current_user)
            Validator.new.call(message, current_user)

            message.destroy

            response(status: :no_content, data: message, message: 'Destroyed')
          end
        end
      end
    end
  end
end
