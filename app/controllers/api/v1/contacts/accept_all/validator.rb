# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module AcceptAll
        # Validates params for accepting all contacts
        class Validator
          # Validates params for accepting all contacts
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
