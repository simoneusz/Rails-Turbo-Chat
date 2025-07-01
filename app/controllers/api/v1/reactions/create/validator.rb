# frozen_string_literal: true

module Api
  module V1
    module Reactions
      module Create
        # Validates params for creating a reaction
        class Validator
          # Validates params for creating a reaction
          #
          # @param params [ActionController::Parameters] params for creating a reaction
          # @return [nil] nil if valid, raises Errors::ValidationError otherwise
          def call(params)
            schema = Api::V1::RequestSchemas::ReactionSchema.new.call(params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
