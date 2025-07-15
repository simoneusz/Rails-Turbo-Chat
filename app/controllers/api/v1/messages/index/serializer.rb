# frozen_string_literal: true

module Api
  module V1
    module Messages
      module Index
        # Serializes a Message instance into a hash
        class Serializer
          # Serialize a message record
          #
          # @param record [Message] message instance to be serialized
          # @return [Hash] serialized message attributes
          def call(record)
            Api::V1::Serializers::MessageSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
