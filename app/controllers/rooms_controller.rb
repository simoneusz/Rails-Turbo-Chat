class RoomsController < ApplicationController
  before_action :set_room_and_user, only: %i[
    add_participant change_role join leave remove_participant block_participant unblock_participant
  ]
  before_action :authorize_room, only: %i[
    add_participant change_role remove_participant block_participant unblock_participant
  ]

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
    @room.remove_participant(current_user, participant) if participant
    redirect_to root_path
  end

  def remove_participant
    set_flash_and_redirect(:alert, "You don't have permission to remove users") unless authorized?(:remove_participant)
    result = Participants::RemoveParticipantService.new(@room, @user).call
    if result
      set_flash_and_redirect(:notice, "#{@user.username} was removed from the room")
    else
      set_flash_and_redirect(:alert, 'Could not remove user')
    end
  end

  def block_participant
    update_role(:blocked, 'blocked', :block_participant)
  end

  def unblock_participant
    update_role(:member, 'unblocked', :block_participant)
  end

  def change_role
    participant = find_participant(@user.id)
    return unless participant

    if authorized?(:change_role)
      role = params[:role]
      participant.update(role: role)
      set_flash_and_redirect(:notice, "#{@user.username} was changed to #{role}")
    else
      set_flash_and_redirect(:alert, "You don't have permission to change role")
    end
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

  def update_role(new_role, action_message, policy_action)
    participant = find_participant(@user.id)
    return unless participant

    if authorized?(policy_action)
      participant.update(role: new_role)
      set_flash_and_redirect(:notice, "#{@user.username} was #{action_message}")
    else
      set_flash_and_redirect(:alert, "You don't have permission to #{action_message} users")
    end
  end

  def render_service_error(result)
    error_message = I18n.t("errors.#{result.error_code}")
    error_message += " #{result.message}" if result.message.present?

    set_flash_and_redirect(:alert, error_message)
  end

  def set_flash_and_redirect(type, message, redirect_path = root_path)
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
