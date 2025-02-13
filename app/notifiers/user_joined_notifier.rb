class UserJoinedNotifier < ApplicationNotifier
  deliver_by :action_cable, format: :to_turbo_stream do |options|
    options.message = lambda { |notification|
      ApplicationController.renderer.render(
        turbo_stream: turbo_stream.append(
          "room_#{notification.params[:room].id}_notifications",
          partial: 'notifications/user_joined',
          locals: { user: notification.params[:user] }
        )
      )
    }
  end

  param :user, :room
end
