# frozen_string_literal: true

module Api
  module V1
    module Notifications
      module MarkAsRead
        # Authorizes a participant to change role
        class Authorizer
          # Authorizes a participant to change role
          #
          # @param current_user [User] current logged user
          # @param notification [Notification] notification instance
          # @return [Notification] notification record if authorized, raises Pundit::NotAuthorizedError otherwise
          def call(current_user, notification)
            Pundit.authorize current_user, notification, :mark_as_read?, policy_class: UserNotificationPolicy
          end
        end
      end
    end
  end
end
