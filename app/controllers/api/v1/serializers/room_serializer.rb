# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class RoomSerializer
        include JSONAPI::Serializer

        attributes :id,
                   :name,
                   :is_private,
                   :created_at,
                   :updated_at,
                   :description,
                   :topic,
                   :creator_id,
                   :room_type

        has_many :messages, serializer: MessageSerializer
      end
    end
  end
end
