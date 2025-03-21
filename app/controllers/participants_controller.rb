# frozen_string_literal: true

class ParticipantsController < ApplicationController
  before_action :set_room_and_user
  before_action :authorize_participant, only: %i[create destroy block unblock change_role]

  def create
    handle_participant_action(:add)
  end

  def destroy
    handle_participant_action(:remove)
  end

  def block
    handle_role_change(:blocked)
  end

  def unblock
    handle_role_change(:member)
  end

  def change_role
    handle_role_change(params[:role])
  end

  def leave
    handle_participant_action(:leave)
  end

  def join
    handle_participant_action(:add)
  end

  private

  def set_room_and_user
    @room = Room.find(params[:room_id])
    @user = User.find_by(id: params[:user_id])
  end

  def handle_participant_action(action)
    result = case action
             when :add
               Participants::AddParticipantService.new(@room, current_user, @user, :member).call
             when :remove
               Participants::RemoveParticipantService.new(@room, current_user, @user).call
             when :leave
               @user = current_user
               Rooms::LeaveRoomService.new(@room, @room.find_participant(@user)).call
             end
    handle_service_result(@room, result, "Participant #{action}ed successfully")
  end

  def handle_role_change(new_role)
    participant = @room.find_participant(@user)
    result = Participants::ChangeParticipantRoleService.new(participant, new_role).call
    handle_service_result(@room, result, "Role changed to #{new_role}")
  end

  def authorize_participant
    participant = @room.find_participant(current_user)
    authorize participant if participant
  end
  #
  # def handle_service_result(result, success_message)
  #   flash[result.success? ? :notice : :alert] =
  #     result.success? ? success_message : result.errors&.full_messages&.join(', ') || result.error.code
  #   redirect_to room_path(@room)
  # end
end
