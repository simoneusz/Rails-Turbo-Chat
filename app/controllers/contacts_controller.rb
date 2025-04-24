# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_user, only: %i[update destroy delete]
  def index
    @contacts = current_user.contacts
  end

  def create
    @user = User.find(params[:contact_id])

    result = Contacts::ContactService.new(current_user, @user).request_contact

    if result.success?
      redirect_to rooms_path, notice: 'Requested contact successfully.'
    else
      redirect_to rooms_path, alert: 'Requested contact could not be created.'
    end
  end

  def update
    Contacts::ContactService.new(current_user, @user).accept_contact

    redirect_to contact_path(@user), notice: 'Request accepted'
  end

  def destroy
    Contacts::ContactService.new(current_user, @user).reject_contact

    redirect_to contacts_path, notice: 'Request destroyed'
  end

  def delete
    Contacts::ContactService.new(current_user, @user).delete_contact

    redirect_to contacts_path, notice: 'Contact deleted'
  end

  def accept_all
    pending_contacts = current_user.pending_contacts
    if pending_contacts.any?
      pending_contacts.each do |contact|
        Contacts::ContactService.new(current_user, contact.user).accept_contact
      end
      set_flash_and_redirect(:notice, 'All contacts has been accepted', contacts_path)
    else
      set_flash_and_redirect(:notice, 'There is no contacts to accept.', contacts_path)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
