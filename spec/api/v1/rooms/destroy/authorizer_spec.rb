# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Destroy::Authorizer do
  subject(:authorizer) { described_class.new.call(room, user) }

  let(:user) { create(:user) }
  let(:room) { create(:room) }

  describe '#call' do
    context 'with valid params and role' do
      before do
        create(:participant, user:, room:, role: :owner)
      end

      it 'returns room record' do
        expect(authorizer).to eq(room)
      end
    end

    context 'with valid params and inappropriate role' do
      before do
        create(:participant, user:, room:, role: :peer)
      end

      it 'raises Pundit::NotAuthorizedError' do
        expect { authorizer }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'with invalid params and when user is not in room' do
      it 'raises Pundit::NotAuthorizedError' do
        expect { authorizer }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
