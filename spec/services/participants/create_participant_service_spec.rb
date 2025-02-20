# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::CreateParticipantService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }

  describe '#call' do
    context 'when participant is successfully created' do
      it 'returns a success response' do
        service = described_class.new(room, user, :member)
        result = service.call

        expect(result).to be_success
        expect(result.data).to be_a(Participant)
        expect(result.data.user).to eq(user)
        expect(result.data.room).to eq(room)
        expect(result.data.role).to eq('member')
      end
    end

    context 'when participant already exists' do
      before { create(:participant, room: room, user: user, role: :member) }

      it 'returns an error' do
        service = described_class.new(room, user, :member)
        result = service.call

        expect(result.status).to eq(false)
        expect(result.error_code).to eq(:participant_already_exists)
      end
    end

    context 'when participant creation fails due to invalid data' do
      it 'returns an error' do
        allow_any_instance_of(Participant).to receive(:save).and_return(false)
        allow_any_instance_of(Participant).to receive_message_chain(:errors, :full_messages, :to_sentence)
          .and_return('Invalid participant')

        service = described_class.new(room, user, :member)
        result = service.call

        expect(result.status).to eq(false)
        expect(result.error_code).to eq(:participant_creation_failed)
        expect(result.data).to eq('Invalid participant')
      end
    end
  end
end
