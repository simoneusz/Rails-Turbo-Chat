# frozen_string_literal: true

module Api
  module V1
    module Participants
      module ChangeRole
        # Orchestrates participant#change_role, #block, #unblock actions
        class Transaction
          include ::TransactionResponse

          # @param params [ActionController::Parameters] params for changing participant role
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @param participant [Participant] participant instance
          # @return [Hash] transaction response with status, data, message
          def call(params, room, current_user, participant)
            authorize = Authorizer.new.call(room, current_user)
            return unless authorize

            Validator.new.call(params)

            result = ::Participants::ChangeParticipantRoleService.new(participant, params[:role]).call

            raise Errors::ServiceError, [result.data, result.error_code] unless result.success?

            response(status: :ok, data: Serializer.new.call(result.data), message: 'Role changed')
          end
        end
      end
    end
  end
end
