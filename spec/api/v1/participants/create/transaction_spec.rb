# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::Create::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(participant_params, room, user, current_user) }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let(:current_user) { create(:user) }
    let(:participant_params) { { user_id: user.id } }

    context 'with valid params' do
      before do
        create(:participant, user: current_user, room:)
      end

      it 'returns a successful response with status :created' do
        expect(transaction[:status]).to eq(:created)
      end

      it 'creates a participant' do
        expect { transaction }.to change(room.participants, :count).by(1)
      end
    end

    context 'when authorization fails' do
      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when validation fails' do
      let(:participant_params) { { user_id: nil } }

      before do
        create(:participant, user: current_user, room:)
      end

      it 'raises validation error' do
        expect { transaction }.to raise_error(Errors::ValidationError)
      end
    end

    context 'when service fails' do
      let(:participant_params) { { user_id: user.id } }

      before do
        create(:participant, user: current_user, room:)
        create(:participant, user:, room:)
      end

      it 'raises service error' do
        expect { transaction }.to raise_error(Errors::ServiceError)
      end
    end
  end
end
