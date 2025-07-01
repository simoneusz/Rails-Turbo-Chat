# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Destroy
        # Validates message#destroy action
        class Validator
          # Validates message#destroy action, currently does nothing
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
