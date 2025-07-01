# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class ParticipantSerializer
        include JSONAPI::Serializer

        attributes :id,
                   :user_id,
                   :room_id,
                   :created_at,
                   :updated_at,
                   :role,
                   :mute_notifications
      end
    end
  end
end
