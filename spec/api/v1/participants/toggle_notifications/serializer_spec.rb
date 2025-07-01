# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::ToggleNotifications::Serializer do
  let(:participant) { create(:participant) }
  let(:serialized_participant) { Api::V1::Serializers::ParticipantSerializer.new(participant).serializable_hash }

  describe '#call' do
    subject(:serializer) { described_class.new.call(participant) }

    it 'return serialized room attributes' do
      expect(serializer).to eq(serialized_participant)
    end
  end
end
