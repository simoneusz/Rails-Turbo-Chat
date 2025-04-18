# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::DestroyService do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:message) { create(:message, room:, user:) }

  describe '#call' do
    context 'when user is the author of the message' do
      subject(:service) { described_class.new(message, room, user).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'destroys the message' do
        message
        expect { service }.to change(Message, :count).by(-1)
      end

      it 'returns nil as data' do
        expect(service.data).to be_nil
      end
    end

    context 'when user is not the author of the message' do
      subject(:service) { described_class.new(message, room, other_user).call }

      it 'does not return service success' do
        expect(service).not_to be_success
      end

      it 'does not destroy the message' do
        message
        expect { service }.not_to change(Message, :count)
      end

      it 'returns error code' do
        expect(service.error_code).to eq(:user_cant_destroy_message)
      end
    end
  end
end
