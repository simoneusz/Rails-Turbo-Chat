# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:toggle]
  before_action :set_user, only: [:toggle]
  before_action :set_favorite, only: [:toggle]

  # TODO: move it to service + tests
  def toggle
    Favorites::FavoritesToggleService.new(@favorite, @room, @user).toggle_favorite
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
