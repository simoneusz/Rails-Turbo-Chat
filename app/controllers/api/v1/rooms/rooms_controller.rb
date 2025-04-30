# frozen_string_literal: true

module Api
  module V1
    module Rooms
      class RoomsController < ApiController
        before_action :set_room, only: %i[show destroy]

        def index
          render json: Api::V1::Serializers::RoomSerializer.new(Room.order(:id)).serializable_hash
        end

        def show
          render json: Api::V1::Serializers::RoomSerializer.new(@room).serializable_hash
        end

        def create
          render json: Api::V1::Rooms::Create::Transaction.new.call(room_params, current_user)
        end

        def update
          render json: Api::V1::Rooms::Update::Transaction.new.call(@room, room_params, current_user)
        end

        def destroy
          render json: Api::V1::Rooms::Destroy::Transaction.new.call(@room, current_user)
        end

        private

        def room_params
          params.require(:room).permit(:name, :is_private, :description, :topic, :owner)
        end

        def set_room
          @room = Room.find(params[:id])
        end
      end
    end
  end
end
