# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::AddParticipantService do
  let(:room) { create(:room) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:invalid_user) { nil }
  let(:role) { :member }

  before do
    room.participants.create(user: owner, role: :owner)
  end

  describe '#call' do
    context 'when the participant is successfully added' do
      subject(:service) { described_class.new(room, owner, member, role).call }

      it 'service returns success' do
        expect(service).to be_success
      end

      it 'service returns participant' do
        expect(service.data).to be_a(Participant)
      end
    end

    context 'when the current user is not an owner' do
      subject(:service) { described_class.new(room, member, member, role).call }

      it 'adds the participant' do
        expect(service.success?).to be(true)
      end
    end

    context 'when the target user is invalid' do
      subject(:service) { described_class.new(room, owner, invalid_user, role).call }

      it 'does not returns success' do
        expect(service.success?).to be(false)
      end

      it 'returns an error code' do
        expect(service.error_code).to eq(:participant_creation_failed)
      end
    end
  end
end
