# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Dms::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(user) }

    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:peer_room) { create(:room, is_private: true) }

    before do
      peer_room.participants.create!(user:, role: :peer)
      peer_room.participants.create!(user:, role: :peer)
    end

    context 'with valid params' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      context 'when returns valid data' do
        let!(:private_room) { create(:room, is_private: true) }

        it 'returns serialized room' do
          expect(transaction[:data].pluck(:id)).to include(peer_room.id.to_s)
        end

        it 'does not return non peer rooms' do
          expect(transaction[:data].pluck(:id)).not_to include(private_room.id.to_s)
        end
      end
    end
  end
end
