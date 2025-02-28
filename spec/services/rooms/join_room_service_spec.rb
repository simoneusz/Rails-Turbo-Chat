# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::JoinRoomService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, room: room, user: user, role: :member) }

  describe '#call' do
    context 'when participant joins' do
      it 'participant joins the room' do
        service = described_class.new(room, participant)
        result = service.call

        expect(result).to be_success
        expect(result.data).to eq(room)
        expect(room.participants.size).to eq(1)
      end
    end
  end
end
