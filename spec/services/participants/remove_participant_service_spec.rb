# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::RemoveParticipantService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:current_user) { create(:user) }

  describe '#call' do
    context 'when participant exists' do
      let!(:participant) { create(:participant, room: room, user: user, role: :member) }

      it 'removes the participant and returns success' do
        service = described_class.new(room, current_user,  user)
        result = service.call

        expect(result).to be_success
        expect(result.data).to eq(participant)
        expect(room.participants.exists?(user_id: user.id)).to be_falsey
      end
    end

    context 'when participant does not exist' do
      it 'returns an error' do
        service = described_class.new(room, current_user,  user)
        result = service.call

        expect(result.success?).to eq(false)
        expect(result.error_code).to eq(:participant_doesnt_exist)
      end
    end
  end
end
