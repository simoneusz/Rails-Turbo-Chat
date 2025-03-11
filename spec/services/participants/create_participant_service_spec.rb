# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::CreateParticipantService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }

  describe '#call' do
    context 'when participant is successfully created' do
      subject(:service) { described_class.new(room, user, :member).call }

      it 'service returns success' do
        expect(service).to be_success
      end

      it 'returns service participant' do
        expect(service.data).to be_a(Participant)
      end
    end

    context 'when participant already exists' do
      subject(:service) { described_class.new(room, user, :member).call }

      before { create(:participant, room:, user:, role: :member) }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:participant_already_exists)
      end
    end

    context 'when participant creation fails due to invalid data' do
      subject(:service) { described_class.new(room, user, :invalid_role).call }

      it 'does not returns service success' do
        expect(service.status).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:participant_creation_failed)
      end
    end
  end
end
