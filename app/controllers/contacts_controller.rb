# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_user, only: %i[update destroy delete]
  def index
    @contacts = current_user.contacts
  end

  def create
    @user = User.find(params[:contact_id])
    @users = User.all_except(current_user)
    if current_user.request_contact(@user)
      redirect_to rooms_path, notice: 'Requested contact successfully.'
    else
      redirect_to rooms_path, alert: 'Requested contact could not be created.'
    end
  end

  def update
    current_user.accept_contact(@user)
    redirect_to contact_path(@user), notice: 'Request accepted'
  end

  def destroy
    current_user.reject_contact(@user)
    redirect_to contacts_path, notice: 'Request destroyed'
  end

  def delete
    current_user.delete_contact(@user)
    redirect_to contacts_path, notice: 'Contact deleted'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
