# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::MarkAsReadService do
  let(:receiver) { create(:user) }
  let(:sender) { create(:user) }
  let(:notification) { create(:notification, sender: sender, receiver: receiver, viewed: false) }

  describe '#call' do
    context 'when receiver marks their notification as read' do
      subject(:service) { described_class.new(notification, receiver).call }

      before { service }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'marks the notification as viewed' do
        expect(notification.viewed).to be(true)
      end

      it 'returns the updated notification' do
        expect(service.data).to eq(notification)
      end
    end

    context 'when a different user tries to mark as read' do
      subject(:service) { described_class.new(notification, other_user).call }

      let(:other_user) { create(:user) }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'does not allow unauthorized update' do
        expect(notification.viewed).to be(false)
      end

      it 'returns service error' do
        expect(service.error_code).to eq(:unauthorized_notify)
      end
    end
  end
end
