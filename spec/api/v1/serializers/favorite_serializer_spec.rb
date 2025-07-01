# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::FavoriteSerializer, type: :serializer do
  subject(:serializer) { described_class.new(favorite) }

  let(:favorite) { create(:favorite) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:user_id) }
    it { is_expected.to serialize_attribute(:room_id) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
  end
end
