# frozen_string_literal: true

module Api
  module V1
    module Favorites
      module Toggle
        class Authorizer
          def call(room, current_user)
            participant = room.find_participant(current_user)
            raise Pundit::NotAuthorizedError, 'You don\'t belong in this room' if participant.nil?
          end
        end
      end
    end
  end
end
