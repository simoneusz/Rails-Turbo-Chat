# frozen_string_literal: true

module Api
  module V1
    module Reactions
      module Create
        class Serializer
          def call(record)
            Api::V1::Serializers::MessageSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
