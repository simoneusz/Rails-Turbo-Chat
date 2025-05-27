# frozen_string_literal: true

module Api
  module V1
    module Users
      module Update
        class Validator
          def call(params)
            schema = Api::V1::RequestSchemas::UserUpdateSchema.new.call(params.to_h)

            raise Errors::ValidationError, schema.errors.to_h if schema.failure?
          end
        end
      end
    end
  end
end
