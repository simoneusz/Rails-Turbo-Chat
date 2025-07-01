# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Delete
        # Authorizes a contact to be deleted
        class Authorizer
          # Authorizes a contact to be deleted
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
