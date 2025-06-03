# frozen_string_literal: true

module Api
  module V1
    module Rooms
      module Show
        # Serializes a Room instance into a hash
        class Serializer
          # Serialize a room record
          #
          # @param records [Room::ActiveRecord_Relation] room instances to be serialized
          # @return [Hash] serialized room attributes
          def call(records)
            Api::V1::Serializers::RoomSerializer.new(records).serializable_hash
          end
        end
      end
    end
  end
end
