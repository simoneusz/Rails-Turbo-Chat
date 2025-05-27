# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Destroy
        # Validates participant#destroy action
        class Validator
          # Validates participant#destroy action, currently does nothing
          #
          # @return [Boolean] true if validation passes
          def call
            true
          end
        end
      end
    end
  end
end
