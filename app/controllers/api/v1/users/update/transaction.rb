# frozen_string_literal: true

module Api
  module V1
    module Users
      module Update
        # Orchestrates user#update action
        class Transaction
          include ::TransactionResponse
          # Orchestrates user#update action
          #
          # @param params [ActionController::Parameters] params for update user
          # @param user [User] user instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(params, user, current_user)
            Authorizer.new.call(user, current_user)
            Validator.new.call(params)

            result = ::Users::UpdateService.new(user.id, params).call
            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :ok, data: Serializer.new.call(result.data), message: 'Updated')
          end
        end
      end
    end
  end
end
