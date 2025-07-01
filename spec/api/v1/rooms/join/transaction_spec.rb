# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Join::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room, current_user) }

    let(:room) { create(:room) }
    let(:current_user) { create(:user) }

    context 'with valid params' do
      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:created)
      end
    end

    context 'when authorization fails' do
      before do
        create(:participant, user: current_user, room:)
      end

      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when service fails' do
      context 'when room is private' do
        let(:room) { create(:room, is_private: true) }

        it 'raises service error' do
          expect do
            transaction.call(room, current_user)
          end.to raise_error(Errors::ServiceError)
        end
      end
    end
  end
end
