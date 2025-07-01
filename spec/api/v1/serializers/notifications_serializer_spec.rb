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
end
