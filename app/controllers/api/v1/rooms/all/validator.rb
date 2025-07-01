# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module All
        # Validates params for room#all action
        class Validator
          # Validates params for room#all action, currently does nothing
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
