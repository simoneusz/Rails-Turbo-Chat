# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UnreadNotificationsSummaryJob, type: :job do
  let(:user) { create(:user) }

  describe '#perform' do
    subject(:job) { described_class.new }

    context 'with users unread notifications' do
      before do
        user.notifications.create(notification_type: 'contact_invite_rejected', item: user, sender: user)
        job.perform
      end

      it 'sends notification' do
        expect(user.notifications.size).to eq(2)
      end

      it 'sends notification with correct type' do
        expect(user.notifications.last.notification_type).to eq('unread_notifications')
      end
    end

    context 'without users unread notifications' do
      before do
        user.notifications.create(notification_type: 'contact_invite_rejected', item: user, sender: user)
        user.notifications.last.update!(viewed: true)
        job.perform
      end

      it 'does not sends a notification' do
        expect(user.notifications.size).to eq(1)
      end
    end

    context 'without users notifications' do
      it 'does not sends a notification' do
        expect(user.notifications.size).to eq(0)
      end
    end

    context 'when job performs more when one time' do
      before do
        user.notifications.create(notification_type: 'contact_invite_rejected', item: user, sender: user)
        job.perform
        job.perform
        job.perform
      end

      it 'does not creates unread_notifications duplicate' do
        expect(user.notifications.where(notification_type: 'unread_notifications').size).to eq(1)
      end
    end
  end
end
