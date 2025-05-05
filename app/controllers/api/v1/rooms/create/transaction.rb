# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Create
        class Transaction
          include ::TransactionResponse

          def call(room_params, current_user)
            authorize = Authorizer.new.call(room_params, current_user)
            return unless authorize

            Validator.new.call(room_params)

            result = ::Rooms::CreateRoomService.new(room_params, current_user).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :created, data: Serializer.new.call(result.data), message: 'Created')
          end
        end
      end
    end
  end
end
