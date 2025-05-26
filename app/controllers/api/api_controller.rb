# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    respond_to :json

    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_default_format

    rescue_from StandardError, with: :handle_internal_error
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from Errors::ValidationError, with: :handle_unprocessable_entity
    rescue_from Errors::ServiceError, with: :handle_unprocessable_entity
    rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
    rescue_from Pundit::NotAuthorizedError, with: :handle_pundit_unauthorized
    rescue_from ActionController::UnknownFormat, with: :handle_unknown_format

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

    # Renders a response from controller action with status inside response [Hash],
    # if there is no status - renders with status :ok
    #
    # @param response [Hash] response from controller
    # @param status [Symbol] status from controller response, default is :ok
    # @return json [JSON] renders response from controller
    def render_response(response, status = :ok)
      render json: response.except(:status), status: response[:status] || status
    end

    def set_default_format
      request.format = :json
    end

    def render_unauthorized
      render json: { errors: { status: 401, title: 'Unauthorized' } }, status: :unauthorized
    end

    def handle_unknown_format
      render json: { errors: { status: 406, title: 'Not Acceptable', message: 'Requested format is not supported' } },
             status: :not_acceptable
    end

    def handle_internal_error(exception)
      # TODO: log exception instead of rendering it
      render json: {
        errors: { status: 500,
                  title: 'Internal Server Error',
                  message: exception.message,
                  backtrace: exception.backtrace }
      }, status: :internal_server_error
    end

    def handle_unprocessable_entity(exception)
      render json: {
        errors: { status: 422, title: 'Unprocessable entity', message: exception.message }
      }, status: :unprocessable_entity
    end

    def handle_pundit_unauthorized(exception)
      render json: {
        errors: { status: 401, title: 'Unauthorized', message: exception.message }
      }, status: :unauthorized
    end

    def record_not_found(exception)
      render json: {
        errors: { status: 404, title: 'Record not found', message: exception.message }
      }, status: :not_found
    end
  end
end
