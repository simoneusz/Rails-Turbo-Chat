# frozen_string_literal: true

module Api
  module V1
    module Users
      module Show
        class Transaction
          def call(params)
            authorize = Api::V1::Users::Show::Authorizer.new.call(params)
            validator = Api::V1::Users::Show::Validator.new.call(params)
            return unless authorize && validator

            Api::V1::Serializers::UserSerializer.new(params[:data])
          end
        end
      end
    end
  end
end
