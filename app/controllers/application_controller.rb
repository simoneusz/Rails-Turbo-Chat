class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_query

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
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username first_name last_name])
  end
end
