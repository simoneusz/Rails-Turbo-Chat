# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Create
        # Authorizes a room to be created
        class Authorizer
          # Authorizes a room to be created
          #
          # @return [Boolean] true, always
          def call(_room_params, _current_user)
            true
          end
        end
      end
    end
  end
end
