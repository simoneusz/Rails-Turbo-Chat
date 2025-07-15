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

  describe '.to_hash' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: room.id,
            name: room.name,
            is_private: room.is_private,
            created_at: room.created_at,
            updated_at: room.updated_at,
            description: room.description,
            topic: room.topic,
            creator_id: room.creator_id
          },
          id: room.id.to_s,
          type: :rooms
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
