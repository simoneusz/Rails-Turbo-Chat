# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Reactions::Create::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(reaction_params, room, message, user) }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let(:message) { create(:message, room:) }
    let(:reaction_params) { { emoji: '🔥' } }

    context 'with valid params' do
      before do
        create(:participant, user:, room:)
      end

      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:created)
      end

      it 'creates a new reaction' do
        expect { transaction }.to change { message.reactions.count }.by(1)
      end

      context 'when reaction already exists' do
        before do
          create(:reaction, message: message, user: user, emoji: '🔥')
        end

        # it happens because reaction_service update existing reaction count
        it 'does not create a new reaction' do
          expect { transaction }.not_to(change { message.reactions.count })
        end
      end
    end

    context 'when authorization fails' do
      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when validation fails' do
      let(:reaction_params) { { emoji: nil } }

      before do
        create(:participant, user:, room:)
      end

      it 'raises validation error' do
        expect { transaction }.to raise_error(Errors::ValidationError)
      end
    end
  end
end
