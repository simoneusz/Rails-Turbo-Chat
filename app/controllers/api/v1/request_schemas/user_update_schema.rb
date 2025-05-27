# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class UserUpdateSchema < ApplicationRequestSchema
        params do
          optional(:first_name).filled(:string, min_size?: 2, max_size?: 20)
          optional(:last_name).filled(:string, min_size?: 2, max_size?: 20)
          optional(:avatar).filled(:string)
          optional(:display_name).filled(:string, min_size?: 2, max_size?: 20)
        end
      end
    end
  end
end
