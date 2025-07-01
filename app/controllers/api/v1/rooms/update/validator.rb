# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Update
        # Validates params for room#update action
        class Validator
          # Validates params for room#update action
          #
          # @param room_params [ActionController::Parameters] params for update room
          # @return [nil] nil if valid, raises Errors::ValidationError otherwise
          def call(room_params)
            schema = Api::V1::RequestSchemas::RoomUpdateSchema.new.call(room_params.to_h)

            raise Errors::ValidationError, schema.to_s if schema.failure?
          end
        end
      end
    end
  end
end
