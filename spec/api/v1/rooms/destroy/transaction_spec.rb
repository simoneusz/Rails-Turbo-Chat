# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Destroy::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room, user) }

    let(:room) { create(:room) }
    let(:user) { create(:user) }

    context 'with valid params and valid user role' do
      before { create(:participant, user:, room:, role: :owner) }

      it 'returns a successful response with status :no_content' do
        expect(transaction[:status]).to eq(:no_content)
      end
    end

    context 'when authorization fails' do
      before { create(:participant, user:, room:, role: :peer) }

      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
