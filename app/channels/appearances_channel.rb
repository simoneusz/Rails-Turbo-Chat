# frozen_string_literal: true

class AppearancesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'appearances_channel'
  end

  def unsubscribed
    stop_stream_from 'appearances_channel'
    offline
  end

  def online
    status = User.statuses[:online]
    broadcast_new_status(status)
  end

  def away
    status = User.statuses[:away]
    broadcast_new_status(status)
  end

  def offline
    status = User.statuses[:offline]
    broadcast_new_status(status)
  end

  def brb
    status = User.statuses[:brb]
    broadcast_new_status(status)
  end

  def receive(data)
    ActionCable.server.broadcast('appearances_channel', data)
  end

  private

  def broadcast_new_status(status)
    current_user.update!(status: status)
  end
end
