# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::LeaveRoomService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, room: room, user: user, role: :member) }

  describe '#call' do
    context 'when participant exists' do
      it 'participant leaves the room' do
        service = described_class.new(room, participant)
        result = service.call

        expect(result).to be_success
        expect(result.data).to eq(room)
        expect(room.participants).to eq([])
      end
    end

    context 'when participant does not exist' do
      it 'returns an error' do
        service = described_class.new(room, nil)
        result = service.call

        expect(result.success?).to eq(false)
        expect(result.error_code).to eq(:participant_doesnt_exist)
      end
    end
  end
end
