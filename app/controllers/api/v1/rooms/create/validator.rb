# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Create
        class Validator
          def call(room_params)
            contract = schema.call(room_params.to_h)
            raise Errors::ValidationError, contract.errors.to_h if contract.failure?
          end

          private

          def schema
            Dry::Schema.Params do
              required(:name).filled(:string, min_size?: 3)
              optional(:is_private).filled(:bool)
              optional(:topic).filled(:string)
              optional(:description).filled(:string)
            end
          end
        end
      end
    end
  end
end
