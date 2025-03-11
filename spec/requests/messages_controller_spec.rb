# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }
  let(:message) { create(:message, user: user, room: room) }

  before { sign_in user }

  describe 'POST #create' do
    context 'when user is a participant' do
      subject(:create_message) { post :create, params: { room_id: room.id, message: { content: 'Hello' } } }

      before do
        room.participants.create(user: user)
        create_message
      end

      it 'creates a new message' do
        expect(room.messages.size).to eq(1)
      end

      it 'assigns message' do
        expect(assigns(:message).content.body.to_plain_text).to eq('Hello')
      end
    end

    context 'when user is not a participant' do
      subject(:create_message) { post :create, params: { room_id: room.id, message: { content: 'Hello' } } }

      before { create_message }

      it 'does not create a message and redirects' do
        expect(room.messages.size).to eq(0)
      end

      it 'redirects to room' do
        expect(response).to redirect_to(room_path(room))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user owns the message' do
      subject(:delete_message) { delete :destroy, params: { room_id: room.id, id: message.id } }

      let!(:message) { create(:message, user: user, room: room) }

      it 'deletes the message' do
        expect { delete_message }.to change(Message, :count).by(-1)
      end
    end

    context 'when user does not own the message' do
      subject(:delete_message) { delete :destroy, params: { room_id: room.id, id: message.id } }

      let!(:message) { create(:message, user: another_user, room: room) }

      it 'raises an error' do
        expect { delete_message }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
