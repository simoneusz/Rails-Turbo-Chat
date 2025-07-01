# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Messages::Destroy::Authorizer do
  subject(:authorizer) { described_class.new.call(message, user) }

  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let!(:participant) { create(:participant, user:, room:, role: :owner) }
  let!(:message) { create(:message, user:, room:) }

  describe '#call' do
    context 'with valid params' do
      it 'returns room record' do
        expect(authorizer).to eq(message)
      end
    end

    context 'with invalid params' do
      context 'when user is not in room' do
        before do
          participant.destroy!
        end

        it 'raises Pundit::NotAuthorizedError' do
          expect { authorizer }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end
end
