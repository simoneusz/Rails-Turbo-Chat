# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_room, only: %i[create destroy]

  def create
    if @room.participant?(current_user)
      @message = current_user.messages.create(msg_params.merge(room: @room))
      define_replied
      @message.mark_as_read! for: current_user
    else
      flash[:alert] = 'You cant send messages here'
      redirect_to room_path(@room)
    end
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy
    redirect_to room_path(@room)
  end

  private

  # TODO: make it to service
  def define_replied
    @message.update!(replied: true) if @message.parent_message_id
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def msg_params
    params.require(:message).permit(:content, :parent_message_id)
  end
end
