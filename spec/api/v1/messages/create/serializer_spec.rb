# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Messages::Create::Serializer do
  let(:participant) { create(:participant) }
  let(:message) { create(:message) }
  let(:serialized_message) { Api::V1::Serializers::MessageSerializer.new(message).serializable_hash }

  describe '#call' do
    subject(:serializer) { described_class.new.call(message) }

    it 'return serialized room attributes' do
      expect(serializer).to eq(serialized_message)
    end
  end
end
