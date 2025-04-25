# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module RequestContact
        class Authorizer
          def call(_params)
            true
          end
        end
      end
    end
  end
end
