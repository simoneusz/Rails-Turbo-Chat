# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :message
  belongs_to :user

  after_create_commit -> { broadcast_replace }
  after_update_commit -> { broadcast_replace }

  private

  def broadcast_replace
    broadcast_replace_to "message_#{message.id}_reactions",
                         target: "reactions_message_#{message.id}",
                         partial: 'messages/message_reactions',
                         locals: { message: message }
  end
end
