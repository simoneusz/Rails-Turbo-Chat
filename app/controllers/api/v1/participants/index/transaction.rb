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
          # @param params [ActionController::Parameters] params for filter participants
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(params, room, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            query = Queries::ParticipantsQuery.new(room.participants, params)
            pagy, participants = query.call

            response(status: :ok,
                     data: Serializer.new.call(participants),
                     message: 'Ok',
                     meta: { pagy: pagy, total_count: pagy.count, total_pages: pagy.pages })
          end
        end
      end
    end
  end
end
