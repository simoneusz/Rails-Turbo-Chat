# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:message) { create(:message, room:) }

  before { sign_in user }

  describe 'POST #create' do
    subject(:post_create) { post :create, params: { message_id: message.id, emoji: '🔥' }, format: :turbo_stream }

    context 'when called with valid params' do
      it 'creates a new reaction' do
        expect { post_create }.to change { message.reactions.count }.by(1)
      end

      it 'responds with no content' do
        expect(post_create).to have_http_status(:no_content)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_reaction) { delete :destroy, params: { message_id: message.id, emoji: '🔥' } }

    context 'when user has reaction on message' do
      before do
        create(:reaction, message: message, user: user)
      end

      it 'deletes the reaction' do
        expect { delete_reaction }.to change { message.reactions.reload.count }.by(-1)
      end
    end
  end
end
