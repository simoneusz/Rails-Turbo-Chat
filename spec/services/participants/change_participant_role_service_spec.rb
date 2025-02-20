# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::ChangeParticipantRoleService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, room: room, user: user, role: :member) }

  describe '#call' do
    context 'when participant exists and role is valid' do
      it 'updates the participant role' do
        service = described_class.new(participant, :moderator)
        result = service.call

        expect(result).to be_success
        expect(result.data).to eq(participant)
        expect(participant.reload.role).to eq('moderator')
      end
    end

    context 'when participant does not exist' do
      it 'returns an error' do
        service = described_class.new(nil, :moderator)
        result = service.call

        expect(result.success?).to eq(false)
        expect(result.error_code).to eq(:participant_doesnt_exist)
      end
    end

    context 'when role is invalid' do
      it 'returns an error' do
        service = described_class.new(participant, :invalid_role)
        result = service.call

        expect(result.success?).to eq(false)
        expect(result.error_code).to eq(:unknown_role)
        expect(participant.reload.role).to eq('member')
      end
    end
  end
end
