# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Messages::Destroy::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(message.id, user) }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let!(:message) { create(:message, room:, user:) }
    let!(:participant) { create(:participant, user:, room:) }

    context 'with valid params' do
      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:no_content)
      end

      it 'deletes a message' do
        expect { transaction }.to change(room.reload.messages, :count).by(-1)
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
    end
  end
end
