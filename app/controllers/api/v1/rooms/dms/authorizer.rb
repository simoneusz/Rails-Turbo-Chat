# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Dms
        # Authorizes a room to be created
        class Authorizer
          # Authorizes a room to be created
          #
          # @return [Boolean] true, always
          def call
            true
          end
        end
      end
    end
  end
end
