# frozen_string_literal: true

module Api
  module V1
    module Participants
      module ToggleNotifications
        # Validates participant#change_role action
        class Validator
          # Validates participant#change_role action, currently does nothing
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
