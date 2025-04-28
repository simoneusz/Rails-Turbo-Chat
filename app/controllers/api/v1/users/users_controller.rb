# frozen_string_literal: true

module Api
  module V1
    module Users
      class UsersController < ApiController
        before_action :set_user, only: %i[show update destroy]

        def index
          render json: Api::V1::Users::Index::Transaction.new.call({ data: User.order(:id),
                                                                     current_user: current_user })
        end

        def show
          render json: Api::V1::Users::Show::Transaction.new.call({ data: User.find(params[:id]),
                                                                    current_user: current_user })
        end

        # TODO: authorize current user
        def update
          render json: Api::V1::Users::Update::Transaction.new.call(data: user_params, user_id: params[:id])
        end

        def destroy; end

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
end
