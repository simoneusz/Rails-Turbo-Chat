# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Messages::Create::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(message_params, room, user) }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let(:message_params) { { content: 'message content', parent_message_id: 1, replied: true } }
    let!(:participant) { create(:participant, user:, room:) }

    context 'with valid params' do
      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:created)
      end

      it 'creates a message' do
        expect { transaction }.to change(room.messages, :count).by(1)
      end
    end

    context 'when authorization fails' do
      context 'when user is not in room' do
        before do
          participant.destroy!
        end

        it 'raises authorization error' do
          expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context 'when user have inappropriate role' do
        before do
          participant.update!(role: :blocked)
        end

        it 'raises authorization error' do
          expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end

    context 'when validation fails' do
      let(:message_params) { {} }

      it 'raises validation error' do
        expect { transaction }.to raise_error(Errors::ValidationError)
      end
    end

    context 'when service fails' do
      let(:message_params) { { content: ' ' } }

      it 'raises service error' do
        expect { transaction }.to raise_error(Errors::ServiceError)
      end
    end
  end
end
