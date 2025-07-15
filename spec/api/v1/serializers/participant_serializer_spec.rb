# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::ParticipantSerializer, type: :serializer do
  subject(:serializer) { described_class.new(participant) }

  let(:participant) { create(:participant) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:user_id) }
    it { is_expected.to serialize_attribute(:room_id) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:role) }
    it { is_expected.to serialize_attribute(:mute_notifications) }
  end

  describe '.to_hash' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: participant.id,
            user_id: participant.user_id,
            room_id: participant.room_id,
            created_at: participant.created_at,
            updated_at: participant.updated_at,
            role: participant.role,
            mute_notifications: participant.mute_notifications
          },
          id: participant.id.to_s,
          type: :participant
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
