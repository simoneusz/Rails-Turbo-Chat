# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Join
        # Validates params for room#join action
        class Validator
          # Validates params for room#join action, currently does nothing
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
