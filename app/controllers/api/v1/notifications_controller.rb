# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < BaseController
      before_action :set_notification, only: %i[mark_as_read]

      def index
        render json: Serializers::NotificationsSerializer.new(current_user.notifications).serializable_hash
      end

      def mark_as_read
        render_response(Api::V1::Notifications::MarkAsRead::Transaction.new.call(current_user, @notification))
      end

      private

      def set_notification
        @notification = current_user.notifications.find(params[:id])
      end
    end
  end
end
