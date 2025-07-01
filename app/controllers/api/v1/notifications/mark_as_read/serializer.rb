# frozen_string_literal: true

module Api
  module V1
    module Notifications
      module MarkAsRead
        # Serializes a Notification instance into a hash
        class Serializer
          # Serialize a notification record
          #
          # @param record [Notification] notification instance to be serialized
          # @return [Hash] serialized notification attributes
          def call(record)
            Api::V1::Serializers::NotificationsSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
