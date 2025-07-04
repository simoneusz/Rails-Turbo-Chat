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
                   :creator_id

        has_many :messages, serializer: MessageSerializer
        has_many :participants, serializer: ParticipantSerializer
      end
    end
  end
end
