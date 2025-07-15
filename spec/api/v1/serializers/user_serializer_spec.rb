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

  describe '.to_hash' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: user.id,
            email: user.email,
            username: user.username,
            first_name: user.first_name,
            last_name: user.last_name,
            created_at: user.created_at,
            updated_at: user.updated_at,
            avatar: user.avatar,
            avatar_url: user.avatar_url,
            display_name: user.display_name,
            status: user.status
          },
          id: user.id.to_s,
          type: :user
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
