# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class ReactionSerializer
        include JSONAPI::Serializer

        attributes :id,
                   :message_id,
                   :user_id,
                   :emoji,
                   :created_at,
                   :updated_at
      end
    end
  end
end
