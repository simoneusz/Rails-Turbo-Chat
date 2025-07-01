# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Index
        # Orchestrates participant#index action
        class Transaction
          include ::TransactionResponse
          # Orchestrates participant#index action
          #
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            response(status: :ok, data: Serializer.new.call(room.participants), message: 'Ok')
          end
        end
      end
    end
  end
end
