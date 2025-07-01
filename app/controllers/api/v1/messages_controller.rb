# frozen_string_literal: true

module Api
  module V1
    class MessagesController < BaseController
      before_action :set_room, only: %i[index create destroy]

      def index
        render json: Api::V1::Serializers::MessageSerializer.new(@room.messages).serializable_hash
      end

      def create
        render_response(Api::V1::Messages::Create::Transaction.new.call(message_params, @room, current_user))
      end

      def destroy
        render_response(Api::V1::Messages::Destroy::Transaction.new.call(params[:id],
                                                                         current_user))
      end

      private

      def set_room
        @room = Room.find(params[:room_id])
      end

      def message_params
        params.require(:message).permit(:content, :parent_message_id)
      end
    end
  end
end
