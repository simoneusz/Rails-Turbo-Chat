# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Contacts::AcceptAll::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(user) }

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:third_user) { create(:user) }
    let(:params) { { contact_id: other_user.id } }

    before do
      Contacts::ContactService.new(other_user, user).request_contact
      Contacts::ContactService.new(third_user, user).request_contact
    end

    context 'with valid params' do
      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      it 'accepts all contacts' do
        expect { transaction }.to change(user.reload.contacts, :count).to(+2)
      end
    end

    context 'when pending contacts is empty' do
      before { Contact.destroy_all }

      it 'does not raises service error' do
        expect { transaction }.not_to raise_error
      end
    end
  end
end
