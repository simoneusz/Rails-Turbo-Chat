# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class UserSerializer
        include JSONAPI::Serializer
        attributes :id,
                   :email,
                   :username,
                   :first_name,
                   :last_name,
                   :created_at,
                   :updated_at,
                   :avatar,
                   :avatar_url,
                   :display_name
      end
    end
  end
end
