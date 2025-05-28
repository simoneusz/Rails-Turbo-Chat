# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class NotificationsSerializer
        include JSONAPI::Serializer

        attributes :id,
                   :item_type,
                   :item_id,
                   :receiver_id,
                   :sender_id,
                   :viewed,
                   :notification_type,
                   :created_at,
                   :updated_at
      end
    end
  end
end
