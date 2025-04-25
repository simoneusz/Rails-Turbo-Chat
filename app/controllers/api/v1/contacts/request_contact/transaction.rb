# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module RequestContact
        class Transaction
          def call(_params)
            authorize = Api::V1::Contacts::Add::Authorizer.call
            validator = Api::V1::Contacts::Add::Validator.call
            return unless authorize && validator

            Api::V1::Contacts::Add::Serializer.call
          end
        end
      end
    end
  end
end
