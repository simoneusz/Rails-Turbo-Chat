# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }

  before { sign_in user }

  describe 'GET #chat' do
    context 'when private room exists' do
      let!(:private_room) do
        Rooms::CreatePeerRoomService.new({ name: 'name',
                                           is_private: true },
                                         user,
                                         another_user)
                                    .call.data
      end

      it 'assigns the existing private room' do
        get :chat, params: { id: another_user.id }
        expect(assigns(:single_room)).to eq(private_room)
      end
    end

    context 'when private room does not exist' do
      it 'creates a new private room' do
        expect do
          get :chat, params: { id: another_user.id }
        end.to change(Room, :count).by(1)

        expect(assigns(:single_room)).to be_persisted
      end
    end

    it 'renders the rooms/index template' do
      get :chat, params: { id: another_user.id }
      expect(response).to render_template('rooms/index')
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user' do
      get :show, params: { id: another_user.id }
      expect(assigns(:user)).to eq(another_user)
    end

    it 'responds with HTML format' do
      get :show, params: { id: another_user.id }, format: :html
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #search' do
    it 'assigns @search_results from Ransack' do
      get :search, params: { q: { search: user.username } }
      expect(assigns(:search_results)).to include(user)
    end

    it 'renders the search_results partial for HTML format' do
      get :search, params: { q: { search: user.username } }, format: :html
      expect(response).to render_template(partial: '_search_results')
    end

    it 'renders Turbo Stream format' do
      get :search, params: { q: { search: user.username } }, format: :turbo_stream
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end
  end
end
