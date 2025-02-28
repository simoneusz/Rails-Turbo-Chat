class RoomsController < ApplicationController
  before_action :set_room_and_user, only: %i[
    add_participant change_role join leave remove_participant block_participant unblock_participant
  ]
  before_action :authorize_room, only: %i[
    add_participant change_role remove_participant block_participant unblock_participant
  ]

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
  end

  def create
    result = Rooms::CreateRoomService.new(room_params, current_user).call
    if result.success?
      redirect_to result.data, success: 'New room has been created'
    else
      render_service_error(result)
    end
  end

  def show
    @single_room = Room.find(params[:id])
    if @single_room.is_private && !@single_room.participants.exists?(user_id: current_user.id)
      redirect_to root_path, alert: 'You do not have permission to view this room' and return
    end

    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
    @message = Message.new

    pagy_messages = @single_room.messages.order(created_at: :desc)
    @pagy, messages = pagy(pagy_messages)
    @messages = messages.reverse

    render 'index'
  end

  def dms
    @dms = Room.all_peer_rooms_for_user(current_user)
    render 'index'
  end
  def add_participant
    result = Participants::AddParticipantService.new(@room, current_user, @user, :member).call
    if result&.success?
      set_flash_and_redirect(:notice, "#{@user.username} was added to the room", room_path(@room))
    else
      render_service_error(result)
    end
  end

  def join
    result = Participants::AddParticipantService.new(@room, current_user, @user, :member).call
    if result&.success?
      set_flash_and_redirect(:notice, "Welcome to #{@room.name}", room_path(@room))
    else
      render_service_error(result)
    end
  end

  def leave
    participant = find_participant(current_user.id)

    result = Rooms::LeaveRoomService.new(@room, participant).call

    if result&.success?
      set_flash_and_redirect(:notice, 'You have been removed from the room')
    else
      render_service_error(result)
    end
  end

  def remove_participant
    set_flash_and_redirect(:alert, "You don't have permission to remove users") unless authorized?(:remove_participant)
    result = Participants::RemoveParticipantService.new(@room, @user).call
    if result.success?
      set_flash_and_redirect(:notice, "#{@user.username} was removed from the room", room_path(@room))
    else
      render_service_error(result, room_path(@room))
    end
  end

  def block_participant
    update_role(:blocked)
  end

  def unblock_participant
    update_role(:member)
  end

  def change_role
    new_role = params[:role]
    update_role(new_role)
  end

  private

  def set_room_and_user
    @room = Room.find_by(id: params[:room_id] || params[:id])
    @user = User.find_by(id: params[:user_id])
  end

  def find_participant(user_id)
    @room.participants.find_by(user_id: user_id)
  end

  def authorized?(action)
    Pundit.policy(current_user, @room).public_send("#{action}?")
  end

  def not_authorized
    set_flash_and_redirect(:alert, 'You are not authorized to perform this action', root_path)
  end

  def update_role(new_role)
    participant = find_participant(@user.id)
    result = Participants::ChangeParticipantRoleService.new(participant, new_role).call
    if result.success?
      set_flash_and_redirect(:notice, "Role for #{participant.user.username} was changed to #{new_role}",
                             room_path(@room))
    else
      render_service_error(result, room_path(@room))
    end
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

  def authorize_room
    authorize @room
  end

  def room_params
    params.require(:room).permit(:name, :is_private)
  end
end
