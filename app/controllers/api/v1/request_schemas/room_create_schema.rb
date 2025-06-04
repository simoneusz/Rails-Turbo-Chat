# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class RoomCreateSchema < ApplicationRequestSchema
        params do
          required(:name).filled(:string, min_size?: 3, max_size?: 20)
          optional(:is_private).filled(:bool)
          optional(:topic).filled(:string, max_size?: 500)
          optional(:description).filled(:string, max_size?: 500)
        end
      end
    end
  end
end
