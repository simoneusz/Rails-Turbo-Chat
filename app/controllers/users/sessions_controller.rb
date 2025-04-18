# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def create
      super
      current_user.update(status: :online, status_changed: false)
    end

    def after_sign_out_path_for(_resource_or_scope)
      rooms_path
    end

    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || root_path
    end
  end
end
