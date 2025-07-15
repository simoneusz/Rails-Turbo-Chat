# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Index
        # Orchestrates message#create action
        class Transaction
          include ::TransactionResponse
          # Orchestrates message#create action
          #
          # @param params [ActionController::Parameters] params for messages query
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(params, room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            query = Queries::MessagesQuery.new(room.messages, params)
            pagy, messages = query.call

            response(status: :ok,
                     data: Serializer.new.call(messages),
                     message: 'Ok',
                     meta: { pagy: pagy, total_count: pagy.count, total_pages: pagy.pages })
          end
        end
      end
    end
  end
end
