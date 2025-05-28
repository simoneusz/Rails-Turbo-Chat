# frozen_string_literal: true

module Api
  module V1
    module Notifications
      module MarkAsRead
        # Validates params for marking a notification as read
        class Validator
          # Validates params for marking a notification as read, currently does nothing
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
