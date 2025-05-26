# frozen_string_literal: true

module Api
  module V1
    module Users
      module Show
        class Serializer
          def call(request)
            Api::V1::Serializers::UserSerializer.new(request).serializable_hash
          end
        end
      end
    end
  end
end
