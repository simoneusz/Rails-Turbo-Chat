# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Dms
        # Orchestrates room#dms action
        class Transaction
          include ::TransactionResponse
          # Orchestrates room#dms action
          #
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(current_user)
            Authorizer.new.call
            Validator.new.call

            rooms = Room.all_peer_rooms_for_user(current_user)

            response(status: :ok, data: Serializer.new.call(rooms), message: 'Ok')
          end
        end
      end
    end
  end
end
