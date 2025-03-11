# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::JoinRoomService do
  let(:room) { create(:room) }
  let(:private_room) { create(:room, is_private: true) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, room: room, user: user, role: :member) }

  describe '#call' do
    context 'when participant joins' do
      subject(:service) { described_class.new(room, user).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'participant joins successfully' do
        expect { service }.to change(Participant, :count).by(1)
      end
    end

    context 'when participant are trying to join private room' do
      subject(:service) { described_class.new(private_room, user).call }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:cant_join_private_room)
      end
    end
  end
end
