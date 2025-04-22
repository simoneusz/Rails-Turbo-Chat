# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[create destroy]

  def create
    result = Messages::ReactionsService.new(@message, current_user, params[:emoji]).create

    respond_to do |format|
      if result.success?
        broadcast_update_to_message

        format.turbo_stream do
          head :no_content
        end
      end
      format.html { redirect_to @message.room }
    end
  end

  def destroy
    result = Messages::ReactionsService.new(@message, current_user, params[:emoji]).destroy
    if result.success?
      broadcast_update_to_message
    else
      redirect_to @message.room
    end
  end

  private

  def broadcast_update_to_message
    turbo_stream = render_to_string partial: 'messages/message_reactions',
                                    locals: { message: @message, current_user: },
                                    formats: [:html]

    Turbo::StreamsChannel.broadcast_update_to(
      "room_#{@message.room.id}_reactions",
      target: "reactions_message_#{@message.id}",
      html: turbo_stream
    )
  end

  def set_message
    @message = Message.find(params[:message_id])
  end
end
