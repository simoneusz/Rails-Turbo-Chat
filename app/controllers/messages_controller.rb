# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    @room = Room.find(params[:room_id])
    if @room.participant?(current_user)
      @message = current_user.messages.create(content: msg_params[:content], room_id: params[:room_id])
    else
      flash[:alert] = 'You cant send messages here'
      redirect_to room_path(@room)
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @message = current_user.messages.find(params[:id])
    @message.destroy
    redirect_to room_path(@room)
  end

  private

  def msg_params
    params.require(:message).permit(:content)
  end
end
