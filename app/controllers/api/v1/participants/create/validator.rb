# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Create
        # Validates params for creating a participant
        class Validator
          # Validates params for creating a participant
          #
          # @param params [ActionController::Parameters] params for creating a participant
          # @return [Hash] transaction response with status, data, message
          def call(params)
            schema = Api::V1::RequestSchemas::ParticipantCreateSchema.new.call(params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
