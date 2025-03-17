# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = Message.find(params[:message_id])
    @reaction = @message.reactions.find_or_initialize_by(user: current_user, emoji: params[:emoji])
    @reaction.count = @reaction.count.to_i + 1
    @reaction.save!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to room_path(@message.room) }
    end
  end
end
