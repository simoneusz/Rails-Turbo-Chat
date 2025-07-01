# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Show::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room, user) }

    let(:room) { create(:room) }
    let(:user) { create(:user) }

    context 'with valid params' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      context 'when returns valid data' do
        let(:serialized_room) { Api::V1::Serializers::RoomSerializer.new(room).serializable_hash }

        it 'returns serialized room' do
          expect(transaction[:data]).to eq(serialized_room[:data])
        end
      end
    end

    context 'when authorization fails' do
      before do
        room.update!(is_private: true)
      end

      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
