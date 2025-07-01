# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::ToggleNotifications::Authorizer do
  subject(:authorizer) { described_class.new.call(room, user) }

  let(:user) { create(:user) }
  let(:room) { create(:room) }

  describe '#call' do
    context 'with valid params' do
      before do
        create(:participant, user:, room:, role: :owner)
      end

      it 'returns room record' do
        expect(authorizer).to eq(room.find_participant(user))
      end
    end

    context 'with invalid params' do
      context 'when user is not in room' do
        it 'raises Pundit::NotAuthorizedError' do
          expect { authorizer }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end
end
