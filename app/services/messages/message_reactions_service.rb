# frozen_string_literal: true

module Messages
  class MessageReactionsService < ApplicationService
    def initialize(message, current_user, emoji)
      super()
      @message = message
      @current_user = current_user
      @emoji = emoji
    end

    def call
      if @message.any_reactions_from_user?(@current_user)
        Rails.logger.info('MessageReactionsServiceMessageReactionsServiceMessageReactionsServiceMessageReactionsServiceMessageReactionsServiceMessageReactionsServiceMessageReactionsServiceMessageReactionsService')
        Rails.logger.info(@message.any_reactions_from_user?(@current_user))
      end
      delete_user_current_reaction

      reaction = new_reaction
      return error(code: 'todo invalid params') unless reaction.valid?

      reaction.save!
      success(reaction)
    end

    private

    def new_reaction
      @message.reactions.new(user: @current_user, emoji: @emoji)
    end

    def delete_user_current_reaction
      @message.reactions.where(user: @current_user).destroy_all
    end
  end
end
