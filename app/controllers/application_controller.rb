# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_query
  before_action :turbo_frame_request_variant

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def set_query
    @query = User.ransack(search_query)
    @users = []

    @search_results = search_query.empty? ? {} : @query.result
  end

  def search_query
    return {} unless params[:q]

    return {} unless params[:q][:search]

    logger.info(params[:q][:search])
    query = params[:q][:search]&.strip
    return {} if query.blank?

    { username_or_email_or_first_name_or_last_name_cont_any: query.split }
  end

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
    if result.success?
      set_flash_and_redirect(:notice, success_message, room_path(current_room) || rooms_path)
    else
      render_service_error(result, rooms_path)
    end
  end
end
