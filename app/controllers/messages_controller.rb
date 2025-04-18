# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_room, only: %i[create destroy]

  def create
    result = Messages::CreationService.new(message_params, @room, current_user).call

    redirect_to room_path(@room), alert: 'You cant send messages here' unless result.success?
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    result = Messages::DestroyService.new(@message, @room, current_user).call

    if result.success?
      redirect_to room_path(@room)
    else
      redirect_to room_path(@room), alert: 'You cant send messages here'
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def message_params
    params.require(:message).permit(:content, :parent_message_id)
  end
end
