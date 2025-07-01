# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Favorites::Toggle::Serializer do
  let(:favorite) { create(:favorite) }
  let(:serialized_favorite) { Api::V1::Serializers::FavoriteSerializer.new(favorite).serializable_hash }

  describe '#call' do
    subject(:serializer) { described_class.new.call(favorite) }

    it 'return serialized room attributes' do
      expect(serializer).to eq(serialized_favorite)
    end
  end
end
