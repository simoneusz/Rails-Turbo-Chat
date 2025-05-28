# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Add
        class Authorizer
          def call
            true
          end
        end
      end
    end
  end
end
