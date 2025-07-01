# frozen_string_literal: true

module Api
  module V1
    module Users
      module ChangeStatus
        # Validates params for user#change_status action
        class Validator
          # Validates params for user#change_status action
          #
          # @param params [ActionController::Parameters] params for changing user status
          # @return [nil] nil if valid, raises Errors::ValidationError otherwise
          def call(params)
            schema = Api::V1::RequestSchemas::UserChangeStatusSchema.new.call(params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
