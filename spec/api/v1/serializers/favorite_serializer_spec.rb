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

  describe '.to_hast' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: favorite.id,
            user_id: favorite.user_id,
            room_id: favorite.room_id,
            created_at: favorite.created_at,
            updated_at: favorite.updated_at
          },
          id: favorite.id.to_s,
          type: :favorite
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
