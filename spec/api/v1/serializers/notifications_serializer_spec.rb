# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::NotificationsSerializer, type: :serializer do
  subject(:serializer) { described_class.new(notification) }

  let(:notification) { create(:notification) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:item_type) }
    it { is_expected.to serialize_attribute(:item_id) }
    it { is_expected.to serialize_attribute(:receiver_id) }
    it { is_expected.to serialize_attribute(:sender_id) }
    it { is_expected.to serialize_attribute(:viewed) }
    it { is_expected.to serialize_attribute(:notification_type) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
  end

  describe '.to_hash' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: notification.id,
            item_type: notification.item_type,
            item_id: notification.item_id,
            receiver_id: notification.receiver_id,
            sender_id: notification.sender_id,
            viewed: notification.viewed,
            notification_type: notification.notification_type,
            created_at: notification.created_at,
            updated_at: notification.updated_at
          },
          id: notification.id.to_s,
          type: :notifications
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
