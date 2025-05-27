# frozen_string_literal: true

module Api
  module V1
    module Participants
      module ChangeRole
        class Serializer
          def call(record)
            Api::V1::Serializers::ParticipantSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
