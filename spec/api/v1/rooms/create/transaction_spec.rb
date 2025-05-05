# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Create::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room_params, current_user) }

    let(:current_user) { create(:user) }

    context 'with valid params' do
      let(:room_params) { { name: 'Valid Room', is_private: false } }

      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:created)
      end
    end

    context 'when validation fails' do
      let(:room_params) { { is_private: false } }

      it 'raises validation error' do
        expect do
          transaction.call(room_params, current_user)
        end.to raise_error(Errors::ValidationError)
      end
    end

    context 'when service fails' do
      let(:room_params) { { name: 'Room', is_private: false } }

      before { create(:room, name: 'Room') }

      it 'raises service error' do
        expect do
          transaction.call(room_params, current_user)
        end.to raise_error(Errors::ServiceError)
      end
    end
  end
end
