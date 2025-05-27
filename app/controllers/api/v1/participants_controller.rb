# frozen_string_literal: true

module Api
  module V1
    class ParticipantsController < ApiController
      before_action :set_participant, only: %i[destroy change_role]
      before_action :set_room
      before_action :set_user, only: %i[create]

      def create
        render_response(Api::V1::Participants::Create::Transaction.new.call(participant_params, @room, @user,
                                                                            current_user))
      end

      def destroy
        render_response(Api::V1::Participants::Destroy::Transaction.new.call(params, @room, @participant,
                                                                             current_user))
      end

      def change_role
        render_response(Api::V1::Participants::ChangeRole::Transaction.new.call(participant_params, @room, current_user,
                                                                                @participant))
      end

      # TODO: get participant id, not users
      def toggle_notifications
        render_response(Api::V1::Participants::ToggleNotifications::Transaction.new.call(@room,
                                                                                         current_user))
      end

      private

      def set_participant
        @participant = Participant.find(params[:participant_id])
      end

      def set_room
        @room = Room.find(params[:room_id])
      end

      def set_user
        @user = User.find(params[:user_id])
      end

      def participant_params
        params.require(:participant).permit(:user_id, :role)
      end
    end
  end
end
