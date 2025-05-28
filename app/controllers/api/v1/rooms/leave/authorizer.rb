# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Leave
        class Authorizer
          def call(room, current_user)
            Pundit.authorize current_user, room, :leave?
          end
        end
      end
    end
  end
end
