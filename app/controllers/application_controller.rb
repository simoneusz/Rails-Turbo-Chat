class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_query

  def set_query
    @query = User.ransack(params[:query])
    @users = []
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username first_name last_name])
  end
end
