# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Notifications::MarkAsRead::Serializer do
  let(:notification) { create(:notification) }
  let(:serialized_notification) { Api::V1::Serializers::NotificationsSerializer.new(notification).serializable_hash }

  describe '#call' do
    subject(:serializer) { described_class.new.call(notification) }

    it 'return serialized room attributes' do
      expect(serializer).to eq(serialized_notification)
    end
  end
end
