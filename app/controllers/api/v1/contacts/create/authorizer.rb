# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Create
        # Authorizes a contact to be created
        class Authorizer
          # Authorizes a contact to be created
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
