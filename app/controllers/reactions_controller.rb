# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:create]

  def create
    result = Messages::MessageReactionsService.new(@message, current_user, params[:emoji]).call
    Rails.logger.debug 'EWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEWEW'
    Rails.logger.debug result.data.class
    if result.success?
      broadcast_append_to_message(result.data)
    else
      redirect_to @message.room
    end
  end

  private

  def broadcast_append_to_message(reaction)
    @message.broadcast_append_to "message_#{@message.id}_reactions",
                                 target: "reactions_message_#{@message.id}",
                                 partial: 'reactions/reaction',
                                 locals: { reaction:, current_user: }
  end

  def set_message
    @message = Message.find(params[:message_id])
  end
end
