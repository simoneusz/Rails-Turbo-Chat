# frozen_string_literal: true

module Messages
  class ReactionsService < ApplicationService
    def initialize(message, current_user, emoji = nil)
      @message = message
      @current_user = current_user
      @emoji = emoji
    end

    def create
      if @message.any_reactions_from_user?(@current_user)
        update_user_current_reaction
      else
        reaction = new_reaction
        return error_reaction_invalid unless reaction.valid?

        reaction.save!
      end

      success(@message)
    end

    def destroy
      return error_no_reaction_by_user unless @message.any_reactions_from_user?(@current_user)

      delete_user_current_reaction

      success(@message)
    end

    private

    def new_reaction
      @message.reactions.new(user: @current_user, emoji: @emoji)
    end

    def delete_user_current_reaction
      @message.reactions.where(user: @current_user).destroy_all
    end

    def update_user_current_reaction
      @message.reactions.where(user: @current_user).update!(emoji: @emoji)
    end

    def error_reaction_invalid
      error(code: CODE_REACTION_INVALID)
    end

    def error_no_reaction_by_user
      error(code: CODE_NO_REACTION_BY_USER)
    end
  end
end
