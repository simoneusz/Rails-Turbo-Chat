# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Notifications::MarkAsRead::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(user, notification) }

    let(:user) { create(:user) }
    let(:notification) { create(:notification, receiver: user) }

    context 'with valid params' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end
    end

    context 'when authorization fails' do
      let(:notification) { create(:notification) }

      it 'raises authorization error' do
        expect { transaction }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
