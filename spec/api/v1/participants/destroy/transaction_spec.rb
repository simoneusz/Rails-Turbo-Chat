# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::Destroy::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(room, participant, current_user) }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let!(:participant) { create(:participant, user:, room:) }
    let(:current_user) { create(:user) }

    context 'with valid params' do
      before do
        create(:participant, user: current_user, room:, role: :owner)
      end

      it 'returns a successful response with status :no_content' do
        expect(transaction[:status]).to eq(:no_content)
      end

      it 'removes the participant' do
        expect { transaction }.to change(room.participants, :count).by(-1)
      end
    end

    context 'when authorization fails' do
      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'with invalid params' do
      let(:participant) { create(:participant, user: current_user, room:) }

      it 'raises service error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
