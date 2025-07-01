# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Show::Authorizer do
  subject(:authorizer) { described_class.new.call(room, user) }

  let(:user) { create(:user) }
  let(:room) { create(:room, is_private: false) }

  describe '#call' do
    context 'with valid params' do
      context 'when user is in room and room is public' do
        before do
          create(:participant, user:, room:)
        end

        it 'returns room record' do
          expect(authorizer).to eq(room)
        end
      end

      context 'when user is not in room and room is public' do
        it 'raises Pundit::NotAuthorizedError' do
          expect(authorizer).to eq(room)
        end
      end
    end

    context 'with invalid params' do
      context 'when room is private and user is not in room' do
        before do
          room.update!(is_private: true)
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
