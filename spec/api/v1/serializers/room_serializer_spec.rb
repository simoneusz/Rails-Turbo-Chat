# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::RoomSerializer, type: :serializer do
  subject(:serializer) { described_class.new(room) }

  let(:room) { create(:room) }

  describe 'associations' do
    it { is_expected.to have_many(:messages).serializer(Api::V1::Serializers::MessageSerializer) }
  end

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:name) }
    it { is_expected.to serialize_attribute(:is_private) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:description) }
    it { is_expected.to serialize_attribute(:topic) }
    it { is_expected.to serialize_attribute(:creator_id) }
  end
end
