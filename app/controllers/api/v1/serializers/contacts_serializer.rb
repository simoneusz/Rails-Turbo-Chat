# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class ContactsSerializer
        include JSONAPI::Serializer

        attributes :id,
                   :user_id,
                   :contact_id,
                   :created_at,
                   :updated_at,
                   :status
      end
    end
  end
end
