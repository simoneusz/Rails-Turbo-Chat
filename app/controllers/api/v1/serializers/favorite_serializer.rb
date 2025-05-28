# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class FavoriteSerializer
        include JSONAPI::Serializer

        attributes :id,
                   :user_id,
                   :room_id,
                   :created_at,
                   :updated_at
      end
    end
  end
end
