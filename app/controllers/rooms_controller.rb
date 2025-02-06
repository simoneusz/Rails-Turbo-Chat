class RoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
  end

  def create
    @room = Room.create(name: room_params[:name], is_private: room_params[:is_private])
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
    @room = Room.new
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc).last(6)
    render 'index'
  end

  def add_participant
    @room = Room.find(params[:id])
    contact = User.find(params[:contact_id])

    return if @room.participants.where(user_id: contact.id).exists?

    @room.send_invitation(current_user, contact)
    flash[:notice] = "#{contact.username} was added to the room"

    redirect_to room_path(@room)
  end

  def accept_invitation
    @room = Room.find(params[:id])
    user = User.find(params[:user_id])
    @room.add_participant(user, :member)
  end

  private

  def room_params
    params.require(:room).permit(:name, :is_private)
  end
end
