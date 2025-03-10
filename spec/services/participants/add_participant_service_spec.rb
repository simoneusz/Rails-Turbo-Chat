# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::AddParticipantService do
  let(:room) { create(:room) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:invalid_user) { nil }
  let(:role) { :member }

  before do
    # Add the owner as a participant of the room
    room.participants.create(user: owner, role: :owner)
  end

  describe '#call' do
    context 'when the participant is successfully added' do
      it 'adds the participant to the room with the correct role' do
        service = described_class.new(room, owner, member, role)
        result = service.call

        expect(result).to be_success
        expect(result.data).to be_a(Participant)
        expect(result.data.user).to eq(member)
        expect(result.data.room).to eq(room)
        expect(result.data.role).to eq(role.to_s)
      end
    end

    context 'when the current user is not an owner' do
      it 'adds the participant to the room with the correct role' do
        service = described_class.new(room, member, member, role)
        result = service.call

        expect(result.success?).to eq(true)
      end
    end

    context 'when the target user is invalid' do
      it 'returns an error' do
        service = described_class.new(room, owner, invalid_user, role)
        result = service.call

        expect(result.success?).to eq(false)
        expect(result.error_code).to eq(:participant_already_exists)
      end
    end
  end
end
