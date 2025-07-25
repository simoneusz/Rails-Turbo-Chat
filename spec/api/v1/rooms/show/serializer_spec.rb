# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Show::Serializer do
  let(:room) { create(:room) }
  let(:serialized_room) { Api::V1::Serializers::RoomSerializer.new(room).serializable_hash }

  describe '#call' do
    subject(:serializer) { described_class.new.call(room) }

    it 'return serialized room attributes' do
      expect(serializer).to eq(serialized_room)
    end
  end
end
