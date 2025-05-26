# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :set_user, only: %i[show update]

      def show
        render_response(Api::V1::Users::Show::Transaction.new.call(params, @user, current_user))
      end

      def update
        render json: Api::V1::Users::Update::Transaction.new.call(data: user_params, user_id: params[:id])
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :avatar, :display_name)
      end
    end
  end
end
