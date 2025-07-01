# frozen_string_literal: true

module Api
  module V1
    module Users
      module ChangeStatus
        # Orchestrates user#change_status action
        class Transaction
          include ::TransactionResponse
          # Orchestrates user#change_status action
          #
          # @param params [ActionController::Parameters] params for change status
          # @param user [User] user instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(params, user, current_user)
            Authorizer.new.call(user, current_user)
            Validator.new.call(params)

            result = ::Users::ChangeStatusService.new(user.id, params[:status]).call
            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :ok, data: Serializer.new.call(result.data), message: 'Updated')
          end
        end
      end
    end
  end
end
