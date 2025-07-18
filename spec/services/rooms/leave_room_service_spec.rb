# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::LeaveRoomService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let!(:participant) { create(:participant, room:, user:, role: :member) }

  describe '#call' do
    context 'when participant exists' do
      subject(:service) { described_class.new(room, participant).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'participant leaves the room' do
        expect { service }.to change(room.participants, :count).by(-1)
      end
    end

    context 'when participant are trying to leave peer room' do
      subject(:service) { described_class.new(peer_room, participant).call }

      let!(:peer_room) { create(:room) }

      before do
        participant.update(role: :peer)
        peer_room.participants.create!(user:, room:, role: :peer)
        peer_room.participants.create!(user:, room:, role: :peer)
      end

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:cant_leave_peer_room)
      end
    end

    context 'when user are trying to leave self room' do
      subject(:service) { described_class.new(self_room, participant).call }

      let!(:self_room) { Room.find_by(name: "#{user.username}_self_room") }

      before do
        user.create_self_room
      end

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:cant_leave_peer_room)
      end
    end

    context 'when participant does not exist' do
      subject(:service) { described_class.new(room, nil).call }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:participant_doesnt_exist)
      end
    end
  end
end
