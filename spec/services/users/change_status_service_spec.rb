# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ChangeStatusService do
  let!(:user) { create(:user, status: 'online') }

  describe '#call' do
    context 'when user is successfully updated to valid status' do
      subject(:service) { described_class.new(user.id, 'away').call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'updates user status' do
        service
        expect(user.reload.status).to eq('away')
      end

      it 'sets status_changed flag' do
        service
        expect(user.reload.status_changed).to be true
      end
    end

    context 'when status is online (no status_changed)' do
      subject(:service) { described_class.new(user.id, 'online').call }

      before { user.update(status_changed: true) }

      it 'sets status_changed to false' do
        service
        expect(user.reload.status_changed).to be false
      end
    end

    context 'when status is invalid' do
      subject(:service) { described_class.new(user.id, 'sleeping').call }

      it 'returns failure' do
        expect(service.success?).to be false
      end

      it 'returns error code' do
        expect(service.error_code).to eq(:user_status_invalid)
      end
    end

    context 'when user is not found' do
      subject(:service) { described_class.new(0, 'away').call }

      it 'returns failure' do
        expect(service.success?).to be false
      end

      it 'returns user not found code' do
        expect(service.error_code).to eq(:user_not_found)
      end
    end
  end
end
