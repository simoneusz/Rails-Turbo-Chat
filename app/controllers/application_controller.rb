# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :turbo_frame_request_variant

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username first_name last_name avatar])
  end

  private

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def not_authorized
    set_flash_and_redirect(:alert, 'You are not authorized to perform this action', rooms_path)
  end

  def render_service_error(result, redirect_path = root_path)
    error_message = I18n.t("errors.#{result.error_code}")
    error_message += " #{result.data.errors.full_messages.join(', ')}" if result.data&.errors&.any?
    set_flash_and_redirect(:alert, error_message, redirect_path)
  end

  def set_flash_and_redirect(type, message, redirect_path = rooms_path)
    flash[type] = message
    redirect_to redirect_path
  end

  def handle_service_result(room, result, success_message)
    current_room = room || result.data
    if !success_message
      redirect_to room_path(current_room) || rooms_path
    elsif result.success?
      set_flash_and_redirect(:notice, success_message, room_path(current_room) || rooms_path)
    else
      render_service_error(result, rooms_path)
    end
  end

  def record_not_found
    raise ActionController::RoutingError, 'Not Found'
  rescue StandardError
    render404
  end

  def render404
    render file: Rails.public_path.join('404.html').to_s, status: :not_found
  end
end
