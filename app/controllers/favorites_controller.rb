# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:toggle]
  before_action :set_user, only: [:toggle]
  before_action :set_favorite, only: [:toggle]

  def toggle
    Favorites::ToggleService.new(@favorite, @room, @user).toggle_favorite

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @room }
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_favorite
    @favorite = current_user.favorite_rooms.find_by(room: @room)
  end

  def set_user
    @user = current_user
  end
end
