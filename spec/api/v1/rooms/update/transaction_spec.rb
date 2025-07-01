# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Update::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room, room_params, user) }

    let(:room_params) { { name: 'New Name', description: 'New Description' } }
    let(:room) { create(:room) }
    let(:user) { create(:user) }

    context 'with valid params and valid user role' do
      before { create(:participant, user:, room:, role: :owner) }

      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end
    end

    context 'when authorization fails' do
      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when validation fails' do
      let(:room_params) { { name: 'a' } }

      before { create(:participant, user:, room:, role: :owner) }

      it 'raises validation error' do
        expect { transaction }.to raise_error(Errors::ValidationError)
      end
    end
  end
end
