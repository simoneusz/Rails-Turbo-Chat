# frozen_string_literal: true

module Api
  module V1
    class FavoritesController < BaseController
      before_action :set_room, only: %i[toggle]

      def toggle
        render_response(Api::V1::Favorites::Toggle::Transaction.new.call(favorite_params, @room, current_user))
      end

      private

      def set_room
        @room = Room.find(favorite_params[:room_id])
      end

      def favorite_params
        params.require(:favorite).permit(:room_id)
      end
    end
  end
end
