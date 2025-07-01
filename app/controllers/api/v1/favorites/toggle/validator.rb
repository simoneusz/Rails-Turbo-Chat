# frozen_string_literal: true

module Api
  module V1
    module Favorites
      module Toggle
        # Validates params for favorite#toggle action
        class Validator
          # Validates params for favorite#toggle action
          #
          # @param room_params [ActionController::Parameters] params for toggle favorite
          # @return [nil] nil if valid, raises Errors::ValidationError otherwise
          def call(room_params)
            schema = Api::V1::RequestSchemas::FavoriteToggleSchema.new.call(room_params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
