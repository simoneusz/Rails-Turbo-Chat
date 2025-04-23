# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::UpdateService do
  let!(:user) { create(:user, first_name: 'Original Name') }
  let(:valid_params) { { first_name: 'Updated Name' } }
  let(:invalid_params) { { email: '' } }

  describe '#call' do
    context 'when user is successfully updated' do
      subject(:service) { described_class.new(user.id, valid_params).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'updates the user attributes' do
        expect { service }.to change { user.reload.first_name }.from('Original Name').to('Updated Name')
      end

      it 'returns the updated user in data' do
        expect(service.data).to eq(user)
      end
    end

    context 'when user update fails due to validation' do
      subject(:service) { described_class.new(user.id, invalid_params).call }

      it 'returns service failure' do
        expect(service).not_to be_success
      end

      it 'does not change the user' do
        expect { service }.not_to(change { user.reload.attributes })
      end

      it 'returns validation errors' do
        expect(service.data).to include("Email can't be blank")
      end
    end

    context 'when user is not found' do
      subject(:service) { described_class.new(999_999, valid_params).call }

      it 'returns service failure' do
        expect(service).not_to be_success
      end

      it 'returns not found error code' do
        expect(service.error_code).to eq(:user_not_found)
      end
    end
  end
end
