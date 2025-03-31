# frozen_string_literal: true

require 'rails_helper'
# TODO: all_contacts
RSpec.describe ContactsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    subject(:get_index) { get :index }

    before do
      create(:contact, user: user, contact: other_user, status: 'accepted')
      create(:contact, user: other_user, contact: user, status: 'accepted')
      get_index
    end

    it 'assigns contacts to @contacts' do
      expect(assigns(:contacts)).to include(other_user)
    end
  end

  describe 'POST #create' do
    subject(:create_contact) { post :create, params: { contact_id: other_user.id } }

    before { create_contact }

    context 'when contact request is successful' do
      it 'redirects to rooms_path' do
        expect(response).to redirect_to(rooms_path)
      end
    end
  end

  describe 'PATCH #update' do
    subject(:update_contact) { patch :update, params: { id: other_user.id } }

    before { update_contact }

    it 'accepts a contact request and redirects with a success notice' do
      expect(response).to redirect_to(contact_path(other_user))
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_contact) { delete :destroy, params: { id: other_user.id } }

    before { delete_contact }

    it 'rejects a contact request and redirects to contacts_path with a success notice' do
      expect(response).to redirect_to(contacts_path)
    end
  end
end
