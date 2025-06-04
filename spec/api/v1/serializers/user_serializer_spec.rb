# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::UserSerializer, type: :serializer do
  subject(:serializer) { described_class.new(user) }

  let(:user) { create(:user) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:email) }
    it { is_expected.to serialize_attribute(:username) }
    it { is_expected.to serialize_attribute(:first_name) }
    it { is_expected.to serialize_attribute(:last_name) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:avatar) }
    it { is_expected.to serialize_attribute(:avatar_url) }
    it { is_expected.to serialize_attribute(:display_name) }
    it { is_expected.to serialize_attribute(:status) }
  end
end
