# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::ChangeParticipantRoleService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, room: room, user: user, role: :member) }

  describe '#call' do
    context 'when participant exists and role is valid' do
      subject(:service) { described_class.new(participant, :moderator).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'returns service participant' do
        expect(service.data).to eq(participant)
      end
    end

    context 'when participant does not exist' do
      subject(:service) { described_class.new(nil, :moderator).call }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:participant_doesnt_exist)
      end
    end

    context 'when role is invalid' do
      subject(:service) { described_class.new(participant, :invalid_role).call }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:unknown_role)
      end
    end
  end
end
