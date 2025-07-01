# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Accept
        # Authorizes a contact to be accepted
        class Authorizer
          # Authorizes a contact to be accepted
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
