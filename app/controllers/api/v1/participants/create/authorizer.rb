# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Create
        # Authorizes a participant to create a participant
        class Authorizer
          # Authorizes a participant to create a participant
          #
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Boolean] true if authorized, false otherwise
          def call(room, current_user)
            participant = room.find_participant(current_user)
            raise Pundit::NotAuthorizedError, 'You don\'t belong in this room' if participant.nil?

            Pundit.authorize current_user, participant, :create?
          end
        end
      end
    end
  end
end
