# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Update
        class Authorizer
          def call(room, current_user)
            participant = room.find_participant(current_user)
            Pundit.authorize current_user, participant, :update?
          end
        end
      end
    end
  end
end
