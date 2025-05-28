# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class ReactionSchema < ApplicationRequestSchema
        params do
          required(:emoji).filled(:string)
        end
      end
    end
  end
end
