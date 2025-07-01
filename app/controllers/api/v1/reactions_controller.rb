# frozen_string_literal: true

module Api
  module V1
    class ReactionsController < BaseController
      before_action :set_message_and_room, only: %i[create destroy]

      def create
        render_response(Api::V1::Reactions::Create::Transaction.new
                                                               .call(reaction_params, @room, @message, current_user))
      end

      def destroy
        render_response(Api::V1::Reactions::Destroy::Transaction.new.call(reaction_params, @message, current_user))
      end

      private

      def set_message_and_room
        @room = Room.find(params[:room_id])
        @message = @room.messages.find(params[:message_id])
      end

      def reaction_params
        params.require(:reaction).permit(:emoji)
      end
    end
  end
end
