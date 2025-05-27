# frozen_string_literal: true

module Api
  module V1
    module Users
      module ChangeStatus
        class Transaction
          include ::TransactionResponse

          def call(params, user, current_user)
            Authorizer.new.call(user, current_user)
            Validator.new.call(params)

            result = ::Users::ChangeStatusService.new(user.id, params[:status]).call
            # TODO: move raises from all transactions to services
            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :ok, data: Serializer.new.call(result.data), message: 'Updated')
          end
        end
      end
    end
  end
end
