# frozen_string_literal: true

module Api
  module V1
    module Favorites
      module Toggle
        class Serializer
          def call(record)
            Api::V1::Serializers::FavoriteSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
