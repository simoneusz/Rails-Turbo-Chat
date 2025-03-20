# frozen_string_literal: true

module Favorites
  class FavoritesToggleService < ApplicationService
    CODE_FAVORITE_DOES_NOT_EXIST = :favorite_doesnt_exist
    CODE_NOT_A_PARTICIPANT = :not_a_participant

    def initialize(favorite, room, user)
      super()
      @favorite = favorite
      @room = room
      @user = user
    end

    def toggle_favorite
      return error_not_a_participant unless @room.participant?(@user)

      if @favorite.nil?
        create_favorite

        return error(@favorite.errors.full_messages) if @favorite.errors.any?
      else
        @favorite.destroy
        @favorite = nil
      end

      success(@favorite)
    end

    private

    def create_favorite
      @favorite = @user.favorite_rooms.create(room: @room)
    end

    def error_favorite_does_not_exist
      error(code: CODE_FAVORITE_DOES_NOT_EXIST)
    end

    def error_not_a_participant
      error(code: CODE_NOT_A_PARTICIPANT)
    end
  end
end
