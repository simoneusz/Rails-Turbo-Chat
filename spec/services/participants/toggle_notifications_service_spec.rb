# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participants::ToggleNotificationsService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:not_participant) { create(:user) }

  before do
    room.participants.create(user:, role: :owner)
  end

  describe '#call' do
    context 'when the participant successfully toggled notifications' do
      subject(:service) { described_class.new(room, user).call }

      it 'service returns success' do
        expect(service).to be_success
      end

      it 'service returns participant' do
        expect(service.data.mute_notifications).to be_truthy
      end
    end

    context 'when participant is not found' do
      subject(:service) { described_class.new(room, not_participant).call }

      it 'service returns failure' do
        expect(service).not_to be_success
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:participant_doesnt_exist)
      end
    end
  end
end
