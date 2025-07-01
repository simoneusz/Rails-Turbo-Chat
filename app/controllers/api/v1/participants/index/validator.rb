# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Index
        # Validates participant#index action
        class Validator
          # Validates participant#index action, currently does nothing
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
