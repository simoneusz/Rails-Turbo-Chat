# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class UserChangeStatusSchema < ApplicationRequestSchema
        params do
          required(:status).filled(:string, included_in?: User.statuses.keys)
        end
      end
    end
  end
end
