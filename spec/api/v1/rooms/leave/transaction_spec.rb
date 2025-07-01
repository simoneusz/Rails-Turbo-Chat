# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Leave::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room, user) }

    let(:room) { create(:room) }
    let(:user) { create(:user) }

    context 'with valid params' do
      before do
        create(:participant, user:, room:)
      end

      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:created)
      end
    end

    context 'when authorization fails' do
      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
