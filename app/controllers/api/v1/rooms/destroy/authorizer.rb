# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Destroy
        class Authorizer
          def call(room, current_user)
            participant = room.find_participant(current_user)
            Pundit.authorize current_user, participant, :destroy?
          end
        end
      end
    end
  end
end
