# frozen_string_literal: true

module Api
  module V1
    module Participants
      module ToggleNotifications
        # Authorizes a participant to toggle notifications
        class Authorizer
          # Authorizes a participant to toggle notifications
          #
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Boolean] true if authorized, raises Pundit::NotAuthorizedError otherwise
          def call(room, current_user)
            participant = room.find_participant(current_user)
            raise Pundit::NotAuthorizedError, 'You don\'t belong in this room' if participant.nil?

            Pundit.authorize current_user, participant, :toggle_notifications?
          end
        end
      end
    end
  end
end
