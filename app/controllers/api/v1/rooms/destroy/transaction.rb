# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Destroy
        class Transaction
          include ::TransactionResponse
          # Orchestrates room#update action
          #
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call(room, current_user)

            room.destroy

            response(status: :no_content, data: room, message: 'Destroyed')
          end
        end
      end
    end
  end
end
