# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::MessageReactionsService do
  let(:user) { create(:user) }
  let(:message) { create(:message) }
  let(:emoji) { '😊' }

  describe '#create' do
    subject(:service) { described_class.new(message, user, emoji).create }

    context 'when user has no existing reaction' do
      it 'returns service success' do
        expect(service).to be_success
      end

      it 'creates a new reaction' do
        expect { service }.to change(message.reactions, :count).by(1)
      end

      it 'returns correct emoji in data' do
        expect(service.data[:emoji]).to eq(emoji)
      end
    end

    context 'when user already reacted' do
      let(:existing_reaction) { create(:reaction, message: message, user: user, emoji: '😢') }

      before { existing_reaction }

      it 'removes the existing reaction' do
        expect { service }.not_to(change { message.reactions.count })
      end

      it 'replaces the reaction with a new one' do
        service
        expect(message.reactions.find_by(user: user).emoji).to eq(emoji)
      end
    end

    context 'when reaction is invalid' do
      let(:emoji) { nil }

      it 'does not create a new reaction' do
        expect { service }.not_to change(message.reactions, :count)
      end

      it 'does not returns service success' do
        expect(service).not_to be_success
      end

      it 'returns service error' do
        expect(service.error_code).to eq(:invalid_reaction)
      end
    end
  end
end
