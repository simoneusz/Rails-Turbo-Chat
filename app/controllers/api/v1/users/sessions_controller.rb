# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json
        skip_before_action :verify_authenticity_token
        skip_before_action :require_no_authentication, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter

        private

        def respond_with(_resource, _opts = {})
          render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: current_user
          }, status: :ok
        end

        def respond_to_on_destroy
          jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                                   Rails.application.credentials.devise_jwt_secret_key!).first
          current_user = User.find(jwt_payload['sub'])

          failure unless current_user
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
