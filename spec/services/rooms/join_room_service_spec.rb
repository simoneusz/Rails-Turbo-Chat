# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::JoinRoomService do
  let(:room) { create(:room) }
  let(:private_room) { create(:room, is_private: true) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, room: room, user: user, role: :member) }

  describe '#call' do
    context 'when participant joins' do
      it 'participant joins successfully' do
        service = described_class.new(room, user)
        result = service.call

        expect(result).to be_success
        expect(result.data.present?).to eq(true)
        expect(room.participants.size).to eq(1)
      end
    end

    context 'when participant are trying to join private room' do
      it 'results an error' do
        service = described_class.new(private_room, participant)
        result = service.call

        expect(result).not_to be_success
        expect(result.error_code).to eq(:cant_join_private_room)
      end
    end
  end
end
