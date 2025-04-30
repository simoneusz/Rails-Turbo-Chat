# frozen_string_literal: true

module Api
  module V1
    module Rooms
      class RoomsController < ApiController
        def index
          render json: Api::V1::Serializers::RoomSerializer.new(Room.all.order(:id)).serializable_hash
        end
      end
    end
  end
end
