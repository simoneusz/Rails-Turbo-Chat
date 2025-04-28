# frozen_string_literal: true

module Api
  module V1
    module Users
      module Update
        class Transaction
          def call(params)
            authorize = Api::V1::Users::Update::Authorizer.new.call(params)
            validator = Api::V1::Users::Update::Validator.new.call(params)
            return unless authorize && validator

            result = ::Users::UpdateService.new(params[:user_id], params[:data]).call
            Api::V1::Serializers::UserSerializer.new(result.data)
          end
        end
      end
    end
  end
end
