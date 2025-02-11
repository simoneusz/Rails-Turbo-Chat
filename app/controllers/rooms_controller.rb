class RoomsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_room, only: %i[add_participant remove_participant block_participant unblock_participant]
  before_action :authorize_room, only: %i[add_participant remove_participant block_participant unblock_participant]
  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      @room.add_participant(current_user, current_user, :owner)
      flash[:success] = 'New room has been created'
    else
      flash[:alert] = @room.errors.full_messages.to_sentence
      render :index
    end
    # @room.add_participant(current_user, :owner)
  end

  def show
    @single_room = Room.find(params[:id])
    if @single_room.is_private && !@single_room.participants.where(user_id: current_user.id).exists?
      redirect_to root_path, alert: 'You do not have permission to view this room'
      return
    end
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc).last(6)
    render 'index'
  end

  def add_participant
    user = User.find(params[:user_id])
    if Pundit.policy(current_user, @room).add_participant?
      @room.add_participant(current_user, user, :member)
      flash[:notice] = "#{user.username} was added to the room"
    else
      flash[:alert] = "You don't have permission to add users"
    end

    redirect_to room_path(@room)
  end

  def remove_participant
    user = User.find(params[:user_id])
    participant = @room.participants.find_by(user_id: user.id)

    if participant && Pundit.policy(current_user, @room).remove_participant?
      participant.destroy
      flash[:notice] = "#{user.username} was removed from the room"
    else
      flash[:alert] = "You don't have permission to remove users"
    end

    redirect_to room_path(@room)
  end

  def block_participant
    user = User.find(params[:user_id])
    participant = @room.participants.find_by(user_id: user.id)
    if Pundit.policy(current_user, @room).block_participant?
      participant.update(role: :blocked)
      flash[:notice] = "#{user.username} was blocked"
    else
      flash[:alert] = "You don't have permission to block users"
    end
    redirect_to room_path(@room)
  end

  def unblock_participant
    user = User.find(params[:user_id])
    participant = @room.participants.find_by(user_id: user.id)
    if Pundit.policy(current_user, @room).block_participant?
      participant.update(role: :member)
      flash[:notice] = "#{user.username} was unblocked"
    else
      flash[:alert] = "You don't have permission to unblock users"
    end
    redirect_to room_path(@room)
  end
  # def accept_invitation
  #   @room = Room.find(params[:id])
  #   recipient = User.find(params[:user_id])
  #   @room.add_participant(current_user, recipient, :member)
  # end

  private

  def set_room
    @room = if params[:room_id].present?
              Room.find(params[:room_id])
            else
              Room.find(params[:id])
            end
  end

  def authorize_room
    authorize @room
  end

  def room_params
    params.require(:room).permit(:name, :is_private)
  end
end
