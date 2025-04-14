# frozen_string_literal: true

class RoomsController < ApplicationController
  include RoomHelper

  before_action :set_room_and_user, only: %i[
    update destroy
  ]

  before_action :set_participant, only: %i[show]

  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.excluding(current_user)
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
    handle_service_result(@single_room, result, 'New room has been created')
  end

  def update
    if @room.update(room_params)
      set_flash_and_redirect(:notice, 'Room was successfully updated', room_path(@room))
    else
      set_flash_and_redirect(:alert, @room.errors.full_messages.join(', '), room_path(@room))
    end
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

  private

  def set_participant
    @room = Room.find_by(id: params[:room_id] || params[:id])
    @current_participant = find_participant(current_user)
  end

  def set_room_and_user
    @room = Room.find_by(id: params[:room_id] || params[:id])
    @user = User.find_by(id: params[:user_id])
  end

  def authorized_to_view?(room)
    room.is_private ? room.participants.exists?(user_id: current_user.id) : true
  end

  def prepare_show_page # rubocop:disable Metrics/AbcSize
    @rooms = Room.public_rooms
    @users = User.excluding(current_user)
    @favorite = current_user.favorite_rooms.find_by(room_id: @single_room.id)
    @message = Message.new
    pagy_events = @single_room.events.order(created_at: :desc)
    @pagy, events = pagy(pagy_events)
    @events = events.reverse
    @first_unread_date = @single_room.messages.unread_by(current_user).first&.created_at&.to_date
    mark_messages_as_read
  end

  def mark_messages_as_read
    unread = @single_room.messages.unread_by(current_user)
    unread.each { |m| m.mark_as_read!(for: current_user) } if unread.exists?
  end

  def find_participant(user_id)
    return nil unless @room

    @room.participants.find_by(user_id: user_id)
  end

  def room_params
    params.require(:room).permit(:name, :is_private, :description, :topic, :owner)
  end
end
