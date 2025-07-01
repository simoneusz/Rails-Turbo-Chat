# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Show
        # Validates params for room#show action
        class Validator
          # Validates params for room#show action, currently does nothing
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
