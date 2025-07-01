# frozen_string_literal: true

module Api
  module V1
    module Contacts
      module Create
        # Serializes a Contact instance into a hash
        class Serializer
          # Serialize a contact record
          #
          # @param record [Contact] contact instance to be serialized
          # @return [Hash] serialized contact attributes
          def call(record)
            Serializers::ContactsSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
