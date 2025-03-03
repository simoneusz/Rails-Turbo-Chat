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
      subject { post :create, params: { room_id: room.id, message: { content: 'Hello' } } }
      before { room.participants.create(user: user) }

      it 'creates a new message' do
        expect { subject }.to change(Message, :count).by(1)

        expect(assigns(:message)).to be_persisted
        expect(assigns(:message).content.body.to_plain_text).to eq('Hello')
      end
    end

    context 'when user is not a participant' do
      subject { post :create, params: { room_id: room.id, message: { content: 'Hello' } } }
      before { allow(room).to receive(:participant?).with(user).and_return(false) }

      it 'does not create a message and redirects' do
        expect { subject }.not_to change(Message, :count)

        expect(flash[:alert]).to eq('You cant send messages here')
        expect(response).to redirect_to(room_path(room))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user owns the message' do
      subject { delete :destroy, params: { room_id: room.id, id: message.id } }
      it 'deletes the message' do
        message

        expect { subject }.to change(Message, :count).by(-1)

        expect(response).to redirect_to(room_path(room))
      end
    end

    context 'when user does not own the message' do
      subject { delete :destroy, params: { room_id: room.id, id: another_message.id } }
      let(:another_message) { create(:message, user: another_user, room: room) }

      it 'raises an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
