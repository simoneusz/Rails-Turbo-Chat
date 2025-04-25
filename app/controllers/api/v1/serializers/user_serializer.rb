# frozen_string_literal: true

module Api
  module V1
    module Serializers
      class UserSerializer
        include JSONAPI::Serializer
        attributes :id, :email, :username
      end
    end
  end
end
