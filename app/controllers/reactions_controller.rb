# frozen_string_literal: true

class ReactionsController < ApplicationController
  def create
    @message = Message.find(params[:message_id])
    @reaction = @message.reactions.find_or_initialize_by(user: current_user, emoji: params[:emoji])
    @reaction.count += 1
    @reaction.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("message_#{@message.id}_reactions", partial: 'messages/message_reactions',
                                                                                      locals: { message: @message })
      end
      format.html { redirect_to room_path(@message.room) }
    end
  end

  def destroy
    message = Message.find(params[:message_id])
    reaction = message.reactions.find_by(emoji: params[:emoji], user: current_user)

    if reaction.count == 1
      reaction.destroy
    else
      reaction.count -= 1
    end
  end
end
