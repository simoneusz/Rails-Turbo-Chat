# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Join
        class Authorizer
          def call(room, current_user)
            Pundit.authorize current_user, room, :join?
          end
        end
      end
    end
  end
end
