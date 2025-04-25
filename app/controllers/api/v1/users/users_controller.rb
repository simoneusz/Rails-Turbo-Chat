# frozen_string_literal: true

module Api
  module V1
    module Users
      class UsersController < ApiController
        before_action :set_user, only: %i[show update destroy]

        def index
          @users = User.all
          render json: @users, serializer: Api::V1::Serializers::UserSerializer
        end

        def show
          render json: @user
        end

        def update; end

        def destroy; end

        private

        def set_user
          @user = User.find(params[:id])
        end
      end
    end
  end
end
