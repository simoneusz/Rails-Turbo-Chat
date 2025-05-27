# frozen_string_literal: true

module Api
  module V1
    module Users
      module Update
        class Serializer
          def call(record)
            Serializers::UserSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
