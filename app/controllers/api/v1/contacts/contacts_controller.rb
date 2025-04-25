# frozen_string_literal: true

module Api
  module V1
    module Contacts
      class ContactsController < ApiController
        before_action :authenticate_user!
        before_action :set_user, only: %i[update destroy delete]

        def index
          render json: current_user.contacts
        end

        def create
          user = User.find(params[:contact_id])
          result = Contacts::ContactService.new(current_user, user).request_contact

          if result.success?
            render json: { message: 'Requested contact successfully.' }, status: :created
          else
            render json: { error: 'Requested contact could not be created.' }, status: :unprocessable_entity
          end
        end

        def update
          Contacts::ContactService.new(current_user, @user).accept_contact
          render json: { message: 'Request accepted' }
        end

        def destroy
          Contacts::ContactService.new(current_user, @user).reject_contact
          render json: { message: 'Request destroyed' }
        end

        def delete
          Contacts::ContactService.new(current_user, @user).delete_contact
          redirect_to request.referer, notice: 'Contact deleted'
        end

        def accept_all
          pending_contacts = current_user.pending_contacts

          if pending_contacts.any?
            pending_contacts.each do |contact|
              Contacts::ContactService.new(current_user, contact.user).accept_contact
            end
            render json: { message: 'All contacts have been accepted' }
          else
            render json: { message: 'There are no contacts to accept.' }
          end
        end

        private

        def set_user
          @user = User.find(params[:id])
        end
      end
    end
  end
end
