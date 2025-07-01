# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::All::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call }

    context 'with valid params' do
      let(:room_params) { { name: 'Valid Room', is_private: false } }

      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      context 'when returns valid data' do
        let!(:room) { create(:room, room_params) }
        let!(:private_room) { create(:room, is_private: true) }

        it 'returns serialized room' do
          expect(transaction[:data].pluck(:id)).to include(room.id.to_s)
        end

        it 'does not return private rooms' do
          expect(transaction[:data].pluck(:id)).not_to include(private_room.id.to_s)
        end
      end
    end
  end
end
