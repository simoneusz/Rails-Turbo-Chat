# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Update
        # Serializes a Room instance into a hash
        class Serializer
          # Serialize a room record
          #
          # @param record [Room] room instance to be serialized
          # @return [Hash] serialized room attributes
          def call(record)
            Api::V1::Serializers::RoomSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
