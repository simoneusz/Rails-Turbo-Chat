# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Join::Authorizer do
  subject(:authorizer) { described_class.new.call(room, user) }

  let(:user) { create(:user) }
  let(:room) { create(:room) }

  describe '#call' do
    context 'with valid params' do
      it 'returns room record' do
        expect(authorizer).to eq(room)
      end
    end

    context 'with invalid params' do
      context 'when user is already in room' do
        before do
          create(:participant, user:, room:, role: :member)
        end

        it 'raises Pundit::NotAuthorizedError' do
          expect { authorizer }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context 'when user is blocked' do
        before do
          create(:participant, user:, room:, role: :blocked)
        end

        it 'raises Pundit::NotAuthorizedError' do
          expect { authorizer }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end
end
