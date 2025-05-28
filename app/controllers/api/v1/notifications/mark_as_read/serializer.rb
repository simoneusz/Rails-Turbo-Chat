# frozen_string_literal: true

module Api
  module V1
    module Notifications
      module MarkAsRead
        class Serializer
          def call(record)
            Api::V1::Serializers::NotificationsSerializer.new(record).serializable_hash
          end
        end
      end
    end
  end
end
