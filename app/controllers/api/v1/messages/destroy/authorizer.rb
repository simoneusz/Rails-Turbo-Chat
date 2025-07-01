# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Destroy
        class Authorizer
          def call(message, current_user)
            participant = message.room.find_participant(current_user)
            raise Pundit::NotAuthorizedError, 'You don\'t belong in this room' if participant.nil?

            Pundit.authorize current_user, message, :destroy?
          end
        end
      end
    end
  end
end
