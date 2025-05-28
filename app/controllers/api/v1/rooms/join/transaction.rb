# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Join
        class Transaction
          include ::TransactionResponse

          def call(room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            result = ::Rooms::JoinRoomService.new(room, current_user).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :created, data: Serializer.new.call(result.data.room), message: 'Created')
          end
        end
      end
    end
  end
end
