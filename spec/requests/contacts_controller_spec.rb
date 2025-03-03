# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    subject { get :index }
    it 'assigns contacts to @contacts' do
      create(:contact, user: user, contact: other_user, status: 'accepted')
      create(:contact, user: other_user, contact: user, status: 'accepted')
      subject
      expect(assigns(:contacts)).to include(other_user)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { contact_id: other_user.id } }
    context 'when contact request is successful' do
      it 'redirects to rooms_path with a success notice' do
        subject
        expect(response).to redirect_to(rooms_path)
        expect(flash[:notice]).to eq('Requested contact successfully.')
      end
    end

    context 'when contact request is unsuccessful' do
      it 'redirects to rooms_path with an alert' do
        allow_any_instance_of(User).to receive(:request_contact).and_return(false)
        subject
        expect(response).to redirect_to(rooms_path)
        expect(flash[:alert]).to eq('Requested contact could not be created.')
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, params: { id: other_user.id } }
    it 'accepts a contact request and redirects with a success notice' do
      allow(user).to receive(:accept_contact).and_return(true)
      subject
      expect(response).to redirect_to(contact_path(other_user))
      expect(flash[:notice]).to eq('Request accepted')
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: other_user.id } }
    it 'rejects a contact request and redirects to contacts_path with a success notice' do
      allow(user).to receive(:reject_contact).and_return(true)
      subject
      expect(response).to redirect_to(contacts_path)
      expect(flash[:notice]).to eq('Request destroyed')
    end
  end
end
