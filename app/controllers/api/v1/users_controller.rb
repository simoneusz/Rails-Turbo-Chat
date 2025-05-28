# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: %i[show update change_status]

      def show
        render_response(Api::V1::Users::Show::Transaction.new.call(params, @user, current_user))
      end

      def update
        render_response(Api::V1::Users::Update::Transaction.new.call(user_params, @user, current_user))
      end

      def change_status
        render_response(Api::V1::Users::ChangeStatus::Transaction.new.call(user_params, @user, current_user))
      end

      private

      def set_user
        @user = User.find(params[:id] || params[:user_id])
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :avatar, :display_name, :status)
      end
    end
  end
end
