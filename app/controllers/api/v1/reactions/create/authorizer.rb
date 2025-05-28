# frozen_string_literal: true

module Api
  module V1
    module Reactions
      module Create
        class Authorizer
          def call(room, current_user)
            participant = room.find_participant(current_user)
            raise Pundit::NotAuthorizedError, 'You don\'t belong in this room' if participant.nil?

            Pundit.authorize current_user, room, :create?, policy_class: ReactionsPolicy
          end
        end
      end
    end
  end
end
