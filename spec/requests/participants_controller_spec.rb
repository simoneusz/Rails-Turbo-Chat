# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }
  let(:participant) { create(:participant, user:, room:, role: :owner) }
  let!(:another_participant) { create(:participant, user: another_user, room:, role: :member) }

  before do
    sign_in user
    participant
  end

  describe 'POST #create' do
    subject(:post_create) { post :create, params: { room_id: room.id, user_id: another_user.id } }

    before do
      allow(controller).to receive(:authorize_participant)
      Participant.destroy_all
    end

    context 'when service succeeds' do
      it 'adds a participant' do
        expect { post_create }.to change { room.participants.count }.by(1)
      end

      it 'redirects to room' do
        post_create
        expect(response).to redirect_to(room_path(room))
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_participant) do
      delete :destroy, params: { room_id: room.id, user_id: user.id, id: another_user.id }
    end

    before { allow(controller).to receive(:authorize_participant) }

    context 'when service succeeds' do
      it 'removes a participant' do
        expect { destroy_participant }.to change { room.participants.reload.count }.by(-1)
      end

      it 'redirects to room' do
        destroy_participant
        expect(response).to redirect_to(room_path(room))
      end
    end
  end

  describe 'PATCH #change_role' do
    subject(:change_role) do
      patch :change_role, params: { room_id: room.id, id: user.id, user_id: another_user.id, role: :moderator }
    end

    before { allow(controller).to receive(:authorize_participant) }

    it 'changes role of the participant' do
      expect do
        change_role
        another_participant.reload
      end.to change(another_participant, :role).from('member').to('moderator')
    end
  end

  describe 'PATCH #block' do
    subject(:block_participant) { patch :block, params: { room_id: room.id, id: user.id, user_id: another_user.id } }

    before { allow(controller).to receive(:authorize_participant) }

    it 'blocks the participant' do
      expect do
        block_participant
        another_participant.reload
      end.to change(another_participant, :role).from('member').to('blocked')
    end
  end

  describe 'PATCH #unblock' do
    subject(:unblock_participant) do
      patch :unblock, params: { room_id: room.id, id: user.id, user_id: another_user.id }
    end

    before do
      another_participant.update(role: :blocked)
      allow(controller).to receive(:authorize_participant)
    end

    it 'unblocks the participant' do
      expect do
        unblock_participant
        another_participant.reload
      end.to change(another_participant, :role).from('blocked').to('member')
    end
  end

  describe 'PATCH #leave' do
    subject(:leave_room) { patch :leave, params: { room_id: room.id, id: user.id } }

    before { allow(controller).to receive(:authorize_participant) }

    it 'removes the current user from the room' do
      expect { leave_room }.to change { room.participants.reload.count }.by(-1)
    end
  end

  describe 'authorization' do
    subject(:destroy_participant) do
      delete :destroy, params: { room_id: room.id, user_id: another_user, id: user.id }
    end

    before do
      allow(controller).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      another_participant.update(role: :peer)
      destroy_participant
    end

    it 'redirects to room path' do
      expect(response).to redirect_to(rooms_path)
    end

    it 'redirects with an alert' do
      expect(flash[:alert]).to eq('You are not authorized to perform this action')
    end
  end
end
