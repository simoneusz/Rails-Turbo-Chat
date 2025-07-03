# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::MessageSerializer, type: :serializer do
  subject(:serializer) { described_class.new(message) }

  let(:message) { create(:message) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:user_id) }
    it { is_expected.to serialize_attribute(:room_id) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:parent_message_id) }
    it { is_expected.to serialize_attribute(:replied) }
    it { is_expected.to serialize_attribute(:content) }
  end
end
