# frozen_string_literal: true

module Messages
  class MessageReactionsService < ApplicationService
    def initialize(message, current_user, emoji = nil)
      super()
      @message = message
      @current_user = current_user
      @emoji = emoji
    end

    def create
      delete_user_current_reaction if @message.any_reactions_from_user?(@current_user)

      reaction = new_reaction
      return error_reaction_invalid unless reaction.valid?

      reaction.save!

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

    def error_reaction_invalid
      error(code: CODE_REACTION_INVALID)
    end

    def error_no_reaction_by_user
      error(code: CODE_NO_REACTION_BY_USER)
    end
  end
end
