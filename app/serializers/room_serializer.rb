# frozen_string_literal: true

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

  has_many :messages
end
