# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Update
        class Validator
          def call(room_params)
            schema = Api::V1::RequestSchemas::RoomUpdateSchema.new.call(room_params.to_h)

            raise Errors::ValidationError, schema.errors.to_h if schema.failure?
          end
        end
      end
    end
  end
end
