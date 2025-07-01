# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Destroy
        # Orchestrates participant#destroy action
        #
        class Transaction
          include ::TransactionResponse
          # Orchestrates participant#destroy action
          #
          # @param room [Room] room instance
          # @param participant [Participant] participant instance
          # @param current_user [User] current logged user
          # @return [Hash] transaction response with status, data, message
          def call(room, participant, current_user)
            Authorizer.new.call(room, current_user)
            Validator.new.call

            result = ::Participants::RemoveParticipantService.new(room, current_user, participant.user).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :no_content, message: 'deleted')
          end
        end
      end
    end
  end
end
