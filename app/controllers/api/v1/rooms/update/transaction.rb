# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Update
        class Transaction
          include ::TransactionResponse
          # Orchestrates room#update action
          #
          # @param room [Room] room instance
          # @param room_params [ActionController::Parameters] params for update room
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(room, room_params, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call(room_params)

            # TODO: move update to service
            room.update!(room_params)
            raise Errors::ServiceError, [room, room.error_code] unless room.valid?

            response(status: :ok, data: Serializer.new.call(room), message: 'Updated')
          end
        end
      end
    end
  end
end
