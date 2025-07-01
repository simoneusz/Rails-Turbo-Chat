# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Destroy
        # Validates params for room#destroy action
        class Validator
          # Validates params for room#destroy action, currently does nothing
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
