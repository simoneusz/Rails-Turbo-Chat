# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class RoomSchema < ApplicationRequestSchema
        params do
          required(:name).filled(:string, min_size?: 3)
          optional(:is_private).filled(:bool)
          optional(:topic).filled(:string)
          optional(:description).filled(:string)
        end
      end
    end
  end
end
