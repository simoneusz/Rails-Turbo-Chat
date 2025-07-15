# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Index::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(Room.all, params) }

    let(:room) { create(:room) }
    let(:params_hash) { { filter: { name: 'Test' } } }
    let(:params) { ActionController::Parameters.new(params_hash) }
    let(:user) { create(:user) }

    context 'with valid params' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      it 'returns serialized room' do
        expect(transaction[:data]).to eq(Api::V1::Rooms::Index::Serializer.new.call(Room.all)[:data])
      end
    end
  end
end
