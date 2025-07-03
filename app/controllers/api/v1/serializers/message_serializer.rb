# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class MessageSerializer
        include JSONAPI::Serializer

        attributes :id,
                   :user_id,
                   :room_id,
                   :created_at,
                   :updated_at,
                   :parent_message_id,
                   :replied

        attribute :content do |object|
          object.content.to_plain_text
        end

        belongs_to :room
        has_many :reactions
      end
    end
  end
end
