# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Reject
        # Authorizes a contact to be rejected
        class Authorizer
          # Authorizes a contact to be rejected
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
