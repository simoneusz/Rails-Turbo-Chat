# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Create
        # Validates params for creating a message
        class Validator
          # Validates params for creating a message
          #
          # @param message_params [ActionController::Parameters] params for creating a message
          # @return [nil] nil if valid, raises Errors::ValidationError otherwise
          def call(message_params)
            schema = Api::V1::RequestSchemas::MessageSchema.new.call(message_params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
