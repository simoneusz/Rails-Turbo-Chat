# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:create]

  def create
    result = Messages::MessageReactionsService.new(@message, current_user, params[:emoji]).create
    if result.success?
      broadcast_update_to_message(result.data)
    else
      redirect_to @message.room
    end
  end

  private

  def broadcast_update_to_message(_reaction)
    @message.broadcast_update_to "message_#{@message.id}_reactions",
                                 target: "reactions_message_#{@message.id}",
                                 partial: 'messages/message_reactions',
                                 locals: { reaction_counter: @message.reaction_counter, message: @message }
  end

  def set_message
    @message = Message.find(params[:message_id])
  end
end
