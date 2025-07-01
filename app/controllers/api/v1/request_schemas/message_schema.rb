# frozen_string_literal: true

module Api
  module V1
    module RequestSchemas
      class MessageSchema < ApplicationRequestSchema
        params do
          required(:content).filled(:string)
          optional(:parent_message_id).filled(:integer)
          optional(:replied).filled(:bool)
        end
      end
    end
  end
end
