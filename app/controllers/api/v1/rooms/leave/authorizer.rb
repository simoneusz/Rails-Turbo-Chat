# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Leave
        # Authorizes a room to be left
        class Authorizer
          # Authorizes a room to be left
          #
          # @param room [Room] room instance
          # @param current_user [User] current logged user
          # @return [Room] room record if authorized, raises Pundit::NotAuthorizedError otherwise
          def call(room, current_user)
            Pundit.authorize current_user, room, :leave?
          end
        end
      end
    end
  end
end
