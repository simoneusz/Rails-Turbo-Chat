class ContactsController < ApplicationController
  def index
    @contacts = current_user.contacts
  end

  def create
    user = User.find(params[:contact_id])
    @users = User.all_except(current_user)
    # current_user.accept_contact(user)
    # redirect_to contact_path(user), notice: "Request sent to #{user.email}"
    if current_user.request_contact(user)
      redirect_to rooms_path, notice: 'Requested contact successfully.'
    else
      redirect_to rooms_path, alert: 'Requested contact could not be created.'
    end
  end

  def update
    user = User.find(params[:id])
    current_user.accept_contact(user)
    redirect_to contact_path(user), notice: 'Request accepted'
  end

  def destroy
    user = User.find(params[:id])
    current_user.reject_contact(user)
    redirect_to contacts_path, notice: 'Request destroyed'
  end
end
