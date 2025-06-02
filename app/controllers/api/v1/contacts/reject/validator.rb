# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Reject
        # Validates params for rejecting a contact
        class Validator
          # Validates params for rejecting a contact
          #
          # @param params [ActionController::Parameters] params for rejecting a contact
          # @return [nil] nil if valid, raises Errors::ValidationError otherwise
          def call(params)
            schema = Api::V1::RequestSchemas::ContactSchema.new.call(params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
