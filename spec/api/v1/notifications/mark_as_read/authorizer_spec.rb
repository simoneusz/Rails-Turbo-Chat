# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Notifications::MarkAsRead::Authorizer do
  subject(:authorizer) { described_class.new.call(user, notification) }

  let(:user) { create(:user) }
  let(:notification) { create(:notification, receiver: user) }

  describe '#call' do
    context 'with valid params' do
      it 'returns room record' do
        expect(authorizer).to eq(notification)
      end
    end

    context 'with invalid params' do
      context 'when user is not the receiver' do
        let(:notification) { create(:notification) }

        it 'raises Pundit::NotAuthorizedError' do
          expect { authorizer }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end
  end
end
