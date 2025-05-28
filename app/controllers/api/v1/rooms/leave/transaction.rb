# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Leave
        class Transaction
          include ::TransactionResponse

          def call(room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            participant = room.find_participant(current_user)
            result = ::Rooms::LeaveRoomService.new(room, participant).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :created, data: Serializer.new.call(result.data), message: 'Created')
          end
        end
      end
    end
  end
end
