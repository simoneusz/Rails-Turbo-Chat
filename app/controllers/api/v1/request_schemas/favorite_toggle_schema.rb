# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      # Validates params for creating a participant
      # @!attribute [r] user_id
      #   @return [Integer] user id
      # @return [Dry::Validation::Result]
      class FavoriteToggleSchema < ApplicationRequestSchema
        params do
          required(:room_id).filled(:integer)
        end
      end
    end
  end
end
