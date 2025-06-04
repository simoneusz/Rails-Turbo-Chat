# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::RoomsSerializer, type: :serializer do
  subject(:serializer) { described_class.new(room) }

  let(:room) { create(:room) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:name) }
    it { is_expected.to serialize_attribute(:is_private) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:description) }
    it { is_expected.to serialize_attribute(:topic) }
    it { is_expected.to serialize_attribute(:creator_id) }

    it { is_expected.not_to serialize_attribute(:room_type) }
  end
end
