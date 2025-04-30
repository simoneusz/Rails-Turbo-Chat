# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Create
        class Authorizer
          def call(_room_params, _current_user)
            true
          end
        end
      end
    end
  end
end
