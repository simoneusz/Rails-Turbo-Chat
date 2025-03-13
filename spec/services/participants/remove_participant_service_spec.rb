# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::RemoveParticipantService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:current_user) { create(:user) }

  describe '#call' do
    context 'when participant exists' do
      subject(:service) { described_class.new(room, current_user, user).call }

      before { create(:participant, room:, user:, role: :member) }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'removes the participant' do
        expect { service }.to change(room.participants, :count).by(-1)
      end
    end

    context 'when participant does not exist' do
      subject(:service) { described_class.new(room, current_user, user).call }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:participant_doesnt_exist)
      end
    end
  end
end
