# frozen_string_literal: true

module Api
  module V1
    class RoomsController < BaseController
      before_action :set_room, only: %i[show destroy update join leave]

      def index
        render json: Api::V1::Serializers::RoomsSerializer.new(Room.order(:id)).serializable_hash
      end

      def show
        render_response(Api::V1::Rooms::Show::Transaction.new.call(@room, current_user))
      end

      def create
        render_response(Api::V1::Rooms::Create::Transaction.new.call(room_params, current_user))
      end

      def update
        render_response(Api::V1::Rooms::Update::Transaction.new.call(@room, room_update_params, current_user))
      end

      def destroy
        render_response(Api::V1::Rooms::Destroy::Transaction.new.call(@room, current_user))
      end

      def join
        render_response(Api::V1::Rooms::Join::Transaction.new.call(@room, current_user))
      end

      def leave
        render_response(Api::V1::Rooms::Leave::Transaction.new.call(@room, current_user))
      end

      def all
        render_response(Api::V1::Rooms::All::Transaction.new.call)
      end

      def dms
        render_response(Api::V1::Rooms::Dms::Transaction.new.call(current_user))
      end

      private

      def room_params
        params.require(:room).permit(:name, :is_private, :description, :topic, :owner)
      end

      def room_update_params
        params.require(:room).permit(:name, :description, :topic)
      end

      def set_room
        @room = Room.find(params[:id])
      end
    end
  end
end
