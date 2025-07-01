# frozen_string_literal: true

module Api
  module V1
    module Users
      module Show
        # Serializes a User instance into a hash
        class Serializer
          # Serialize a user record
          #
          # @param record [User] user instance to be serialized
          # @return [Hash] serialized user attributes
          def call(record)
            Serializers::UserSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
