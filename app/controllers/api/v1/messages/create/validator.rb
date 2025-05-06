# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Create
        class Validator
          def call(message_params)
            schema = Api::V1::RequestSchemas::MessageSchema.new.call(message_params.to_h)
            raise Errors::ValidationError, schema.errors.to_h if schema.failure?
          end
        end
      end
    end
  end
end
