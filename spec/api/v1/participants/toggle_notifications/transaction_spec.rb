# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::ToggleNotifications::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room, user) }

    let(:room) { create(:room) }
    let(:user) { create(:user) }
    let!(:participant) { create(:participant, user:, room:) }

    context 'with valid params and valid user role' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      it 'returns serialized participant' do
        expect([transaction[:data]]).to eq(Api::V1::Participants::Index::Serializer.new.call(room.participants)[:data])
      end

      context 'when service succeeds' do
        before do
          participant.update!(mute_notifications: false)
          transaction
        end

        it 'toggles participant notifications' do
          expect(participant.reload.mute_notifications).to be_truthy
        end
      end
    end

    context 'when authorization fails' do
      before do
        participant.update!(role: :blocked)
      end

      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
