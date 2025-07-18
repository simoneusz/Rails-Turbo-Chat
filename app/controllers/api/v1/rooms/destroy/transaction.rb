# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Destroy
        # Orchestrates room#destroy action
        class Transaction
          include ::TransactionResponse
          # Orchestrates room#destroy action
          #
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            room.destroy

            response(status: :no_content, data: nil, message: 'Destroyed')
          end
        end
      end
    end
  end
end
