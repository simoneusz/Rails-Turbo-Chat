# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::ChangeRole::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(participant_params, room, user, participant) }

    let(:room) { create(:room) }
    let(:user) { create(:user) }
    let(:participant) { create(:participant, user:, room:, role: :moderator) }
    let(:participant_params) { { role: 'member' } }

    context 'with valid params and valid user role' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      it 'changes participant role' do
        expect { transaction }.to change(participant, :role).from('moderator').to('member')
      end
    end

    context 'when validation fails' do
      let(:participant_params) { { role: 'invalid' } }

      it 'raises validation error' do
        expect { transaction }.to raise_error(Errors::ValidationError)
      end
    end

    context 'when authorization fails' do
      before do
        participant.update!(role: :peer)
      end

      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
