# frozen_string_literal: true

module Api
  module V1
    module Users
      module Show
        # Orchestrates user#show action
        class Transaction
          include ::TransactionResponse
          # Orchestrates user#show action
          #
          # @param user [User] user instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(user, current_user)
            Authorizer.new.call(user, current_user)
            Validator.new.call

            response(status: :ok, data: Serializer.new.call(user), message: 'Ok')
          end
        end
      end
    end
  end
end
