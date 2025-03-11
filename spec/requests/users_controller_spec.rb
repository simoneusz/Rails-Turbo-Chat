# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }

  before { sign_in user }

  describe 'GET #chat' do
    context 'when private room does not exist' do
      subject(:get_chat) { get :chat, params: { id: another_user.id } }

      it 'creates a new private room' do
        expect { get_chat }.to change(Room, :count).by(1)
      end

      it 'renders the rooms/index template' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #show' do
    subject(:get_show) { get :show, params: { id: another_user.id } }

    before { get_show }

    it 'assigns the requested user' do
      expect(assigns(:user)).to eq(another_user)
    end

    it 'responds with HTML format' do
      expect(response.headers['content-type']).to eq('text/html; charset=utf-8')
    end
  end

  describe 'GET #search' do
    context 'when requesting html format' do
      subject(:get_search) { get :search, params: { q: { search: user.username } } }

      before { get_search }

      it 'assigns @search_results from Ransack' do
        expect(assigns(:search_results)).to include(user)
      end

      it 'renders the search_results partial for HTML format' do
        expect(response.headers['content-type']).to eq('text/html; charset=utf-8')
      end
    end

    context 'when requesting turbo_stream format' do
      subject(:get_search) { get :search, params: { q: { search: user.username } }, format: :turbo_stream }

      before { get_search }

      it 'renders Turbo Stream format' do
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end
  end
end
