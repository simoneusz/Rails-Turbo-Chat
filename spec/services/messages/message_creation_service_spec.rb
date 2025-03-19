# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::MessageCreationService do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:participant) { create(:participant, room:, user:, role: :member) }
  let(:valid_message_params) { { parent_message_id: nil, content: 'text', room_id: room.id } }
  let(:invalid_message_params) { { parent_message_id: nil, content: nil, room_id: room.id } }

  describe '#call' do
    context 'when room is successfully created' do
      subject(:service) { described_class.new(valid_message_params, room, user).call }

      before { participant }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'creates a message' do
        expect { service }.to change(Message, :count).by(1)
      end

      it 'returns message in data' do
        expect(service.data).to eq(Message.last)
      end
    end

    context 'when room does not successfully created' do
      subject(:service) { described_class.new(invalid_message_params, room, user).call }

      before { participant }

      it 'does not returns service success' do
        expect(service.status).to be_falsy
      end

      it 'does not create a message' do
        expect { service }.not_to change(Message, :count)
      end

      it 'assigns user as owner' do
        expect(service.data).not_to be_empty
      end
    end

    context 'when participant does not exists' do
      subject(:service) { described_class.new(valid_message_params, room, user).call }

      it 'does not returns service success' do
        expect(service).not_to be_success
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:participant_doesnt_exist)
      end
    end
  end
end
