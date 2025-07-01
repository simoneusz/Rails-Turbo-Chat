# frozen_string_literal: true

module Api
  module V1
    module Favorites
      module Toggle
        # Serializes a Favorite instance into a hash
        class Serializer
          # Serialize a favorite record
          #
          # @param record [Favorite] favorite instance to be serialized
          # @return [Hash] serialized favorite attributes
          def call(record)
            Api::V1::Serializers::FavoriteSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
