# frozen_string_literal: true

# RoomsController handles all actions related to room management, including creating and viewing rooms,
# adding/removing/changing role participants.
class RoomsController < ApplicationController
  before_action :set_room_and_user, only: %i[
    add_participant change_role join destroy leave remove_participant block_participant unblock_participant
  ]
  before_action :authorize_participant, only: %i[
    add_participant destroy change_role remove_participant block_participant unblock_participant
  ]

  before_action :set_participant, only: %i[show]

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
  end

  def show
    @single_room = Room.find(params[:id])

    unless authorized_to_view?(@single_room)
      return redirect_to rooms_path, alert: 'You do not have permission to view this room'
    end

    return redirect_to rooms_path, alert: 'You are banned in this room' if @single_room.user_blocked?(current_user)

    prepare_show_page
    render 'index'
  end

  def create
    result = Rooms::CreateRoomService.new(room_params, current_user).call
    handle_service_result(result, 'New room has been created')
  end

  def destroy
    @room.destroy
    set_flash_and_redirect(:notice, 'Room has been deleted', rooms_path)
  end

  def all
    @rooms = Room.public_rooms
    @pagy, pagy_rooms = pagy(@rooms.order(created_at: :desc), limit: 15)
    @rooms = pagy_rooms.reverse
  end

  def dms
    @dms = Room.all_peer_rooms_for_user(current_user)
    render 'index'
  end

  def add_participant
    handle_participant_action(:add)
  end

  def join
    handle_participant_action(:add)
  end

  def leave
    handle_participant_action(:remove)
  end

  def remove_participant
    handle_participant_action(:remove)
  end

  def block_participant
    handle_role_change(:blocked)
  end

  def unblock_participant
    handle_role_change(:member)
  end

  def change_role
    handle_role_change(params[:role])
  end

  private

  def set_participant
    @room = Room.find_by(id: params[:room_id] || params[:id])
    @participant = find_participant(current_user)
  end

  def set_room_and_user
    @room = Room.find_by(id: params[:room_id] || params[:id])
    @user = User.find_by(id: params[:user_id])
  end

  def authorized_to_view?(room)
    room.is_private ? room.participants.exists?(user_id: current_user.id) : true
  end

  def prepare_show_page
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
    @message = Message.new
    pagy_messages = @single_room.messages.order(created_at: :desc)
    @pagy, messages = pagy(pagy_messages)
    @messages = messages.reverse
    mark_messages_as_read
  end

  def mark_messages_as_read
    return unless @single_room.messages.unread_by(current_user).exists?

    @single_room.messages.each { |message| message.mark_as_read! for: current_user }
  end

  def handle_participant_action(action)
    result = case action
             when :add
               Participants::AddParticipantService.new(@room, current_user, @user, :member).call
             when :remove
               Participants::RemoveParticipantService.new(@room, current_user, @user).call
             end
    return unless result

    handle_service_result(result, "#{@user.username} was #{action == :add ? 'added in' : 'removed from'}  the room")
  end

  def handle_role_change(new_role)
    participant = find_participant(@user)
    result = Participants::ChangeParticipantRoleService.new(participant, new_role).call
    handle_service_result(result, "Role for #{@user.username} changed to #{new_role}")
  end

  def handle_service_result(result, success_message)
    current_room = @room || result.data
    if result.success?
      set_flash_and_redirect(:notice, success_message, room_path(current_room))
    else
      render_service_error(result, rooms_path)
    end
  end

  def find_participant(user_id)
    @room.participants.find_by(user_id: user_id)
  end

  def authorized?(action)
    Pundit.policy(current_user, @room).public_send("#{action}?")
  end

  def not_authorized
    set_flash_and_redirect(:alert, 'You are not authorized to perform this action', rooms_path)
  end

  def render_service_error(result, redirect_path = root_path)
    error_message = I18n.t("errors.#{result.error_code}")
    error_message += " #{result.data.errors.full_messages.join(', ')}" if result.data&.errors&.any?
    set_flash_and_redirect(:alert, error_message, redirect_path)
  end

  def set_flash_and_redirect(type, message, redirect_path = rooms_path)
    flash[type] = message
    redirect_to redirect_path
  end

  def authorize_participant
    participant = find_participant(current_user)
    authorize participant if participant
  end

  def room_params
    params.require(:room).permit(:name, :is_private)
  end
end
