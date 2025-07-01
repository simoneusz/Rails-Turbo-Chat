# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        skip_before_action :verify_authenticity_token
        skip_before_action :require_no_authentication, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter

        def respond_with(resource, _opts = {})
          return failure unless resource.persisted?

          success
        end

        def success
          render json: {
            status: { code: 200, message: 'Signed up successfully.' },
            data: resource
          }, status: :ok
        end

        def failure
          render json: {
            status: 422,
            errors: resource.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
