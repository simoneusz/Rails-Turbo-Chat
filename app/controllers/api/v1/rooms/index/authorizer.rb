# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Index
        class Authorizer
          # Authorizes a room to be shown
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
