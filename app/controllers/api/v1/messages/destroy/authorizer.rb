# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Destroy
        # Authorizes a message to be destroyed
        class Authorizer
          # Authorizes a message to be destroyed
          #
          # @param message [Message] message instance
          # @param current_user [User] current logged user
          # @return [Message] message record if authorized, raises Pundit::NotAuthorizedError otherwise
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
