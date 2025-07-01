# frozen_string_literal: true

module Api
  module V1
    module Favorites
      module Toggle
        # Authorizes a favorite to be toggled
        class Authorizer
          # Authorizes a favorite to be toggled
          #
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Boolean] true if authorized, raises Pundit::NotAuthorizedError otherwise
          def call(room, current_user)
            participant = room.find_participant(current_user)
            raise Pundit::NotAuthorizedError, 'You don\'t belong in this room' if participant.nil?
          end
        end
      end
    end
  end
end
