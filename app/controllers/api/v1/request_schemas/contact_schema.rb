# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class ContactSchema < ApplicationRequestSchema
        params do
          required(:contact_id).filled(:integer)
        end
      end
    end
  end
end
