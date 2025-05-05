# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    respond_to :json

    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from Errors::ValidationError, with: :handle_custom_error
    rescue_from Errors::ServiceError, with: :handle_custom_error

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[username first_name last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[username first_name last_name avatar])
    end

    def authenticate_user!
      unless user_signed_in?
        render_unauthorized
        return
      end

      super
    end

    private

    def render_unauthorized
      render json: { errors: { status: 401, title: 'Unauthorized' } }, status: :unauthorized
    end

    def handle_custom_error(exception)
      render json: {
        errors: { status: 422, title: 'Unprocessable entity', message: exception.message }
      }, status: :unprocessable_entity
    end

    def current_user
      current_user
    end
  end
end
