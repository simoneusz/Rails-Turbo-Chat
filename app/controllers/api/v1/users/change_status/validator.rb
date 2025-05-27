# frozen_string_literal: true

module Api
  module V1
    module Users
      module ChangeStatus
        class Validator
          def call(params)
            schema = Api::V1::RequestSchemas::UserChangeStatusSchema.new.call(params.to_h)
            # TODO: move hash to string transformation to Validator base class or override dry message to_s
            errors = schema.errors.to_h.map { |field, messages| "#{field}: #{messages.join(', ')}" }.join('; ')
            raise Errors::ValidationError, errors unless errors.empty?
          end
        end
      end
    end
  end
end
