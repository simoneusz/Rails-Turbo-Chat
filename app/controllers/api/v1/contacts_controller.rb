# frozen_string_literal: true

module Api
  module V1
    class ContactsController < BaseController
      before_action :set_user, only: %i[create accept delete reject]

      def index
        render json: Api::V1::Serializers::UserSerializer.new(current_user.contacts.order(:id)).serializable_hash
      end

      def create
        render_response(Api::V1::Contacts::Create::Transaction.new.call(contact_params, current_user, @user))
      end

      def accept
        render_response(Api::V1::Contacts::Accept::Transaction.new.call(contact_params, current_user, @user))
      end

      def delete
        render_response(Api::V1::Contacts::Delete::Transaction.new.call(contact_params, current_user, @user))
      end

      def reject
        render_response(Api::V1::Contacts::Reject::Transaction.new.call(contact_params, current_user, @user))
      end

      def accept_all
        render_response(Api::V1::Contacts::AcceptAll::Transaction.new.call(current_user))
      end

      private

      def set_user
        @user = User.find(contact_params[:contact_id])
      end

      def contact_params
        params.require(:contact).permit(:contact_id)
      end
    end
  end
end
