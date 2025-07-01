# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Favorites::Toggle::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(params, room, user) }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let(:params) { { room_id: room.id } }

    context 'with valid params' do
      before do
        create(:participant, user:, room:)
      end

      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:created)
      end
    end

    context 'when favorite exists' do
      before do
        create(:participant, user:, room:)
        create(:favorite, user:, room:)
      end

      it 'returns a successful response with status :no_content' do
        expect(transaction[:status]).to eq(:no_content)
      end

      it 'deletes favorite record if it was existing' do
        expect { transaction }.to change(Favorite.all, :count).by(-1)
      end
    end

    context 'when authorization fails' do
      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
