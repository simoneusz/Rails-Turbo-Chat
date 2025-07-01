# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::ParticipantSerializer, type: :serializer do
  subject(:serializer) { described_class.new(participant) }

  let(:participant) { create(:participant) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:user_id) }
    it { is_expected.to serialize_attribute(:room_id) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:role) }
    it { is_expected.to serialize_attribute(:mute_notifications) }
  end
end
