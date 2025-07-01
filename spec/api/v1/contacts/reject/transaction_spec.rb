# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Contacts::Reject::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(params, user, other_user) }

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:params) { { contact_id: other_user.id } }

    before { Contacts::ContactService.new(other_user, user).request_contact }

    context 'with valid params' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end
    end
  end
end
