class ContactsController < ApplicationController
  def index
    @contacts = current_user.contacts
    @pending_contacts = current_user.pending_contacts
  end

  def create
    user = User.find(params[:contact_id])
    current_user.accept_contact(user)
    redirect_to contact_path(user), notice: "Request sent to #{user.email}"
  end

  def update
    user = User.find(params[:id])
    current_user.accept_contact(user)
    redirect_to contact_path(user), notice: 'Request accepted'
  end

  def destroy
    user = User.find(params[:id])
    current_user.reject_contact(user)
    redirect_to contact_path(user), notice: 'Request destroyed'
  end
end
