# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomEvent do
  subject { create(:room_event, :with_message) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:eventable_type) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:room) }
    it { is_expected.to belong_to(:eventable) }
  end

  describe 'creating a RoomEvent' do
    let!(:room) { create(:room) }

    context 'when created from a message' do
      subject(:room_event) { create(:room_event, eventable: message, room: room) }

      let!(:message) { create(:message, room: room) }

      it 'sets eventable as message' do
        expect(room_event.eventable).to eq(message)
      end

      it 'sets eventable_type as Message' do
        expect(room_event.eventable_type).to eq('Message')
      end
    end

    context 'when created from a room_notification' do
      subject(:room_event) { create(:room_event, eventable: notification, room: room) }

      let!(:notification) { create(:room_notification, :room_item) }

      it 'sets eventable as notifications' do
        expect(room_event.eventable).to eq(notification)
      end

      it 'sets eventable_type as RoomNotification' do
        expect(room_event.eventable_type).to eq('RoomNotification').or eq('Notification')
      end
    end
  end
end
