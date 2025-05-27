# frozen_string_literal: true

module Api
  module V1
    module Participants
      module Create
        # Serializes a Participant instance into a hash
        class Serializer
          # Serialize a participant record
          #
          # @param record [Participant] participant instance to be serialized
          # @return [Hash] serialized participant attributes
          def call(record)
            Api::V1::Serializers::ParticipantSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
