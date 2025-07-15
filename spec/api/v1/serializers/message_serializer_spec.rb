# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::MessageSerializer, type: :serializer do
  subject(:serializer) { described_class.new(message) }

  let(:message) { create(:message) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:user_id) }
    it { is_expected.to serialize_attribute(:room_id) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:parent_message_id) }
    it { is_expected.to serialize_attribute(:replied) }
    it { is_expected.to serialize_attribute(:content) }
  end

  describe '.to_hash' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: message.id,
            user_id: message.user_id,
            room_id: message.room_id,
            created_at: message.created_at,
            updated_at: message.updated_at,
            parent_message_id: message.parent_message_id,
            replied: message.replied,
            content: message.content.to_plain_text
          },
          relationships: {
            room: {
              data: {
                id: message.room_id.to_s,
                type: :room
              }
            },
            reactions: {
              data: []
            }
          },
          id: message.id.to_s,
          type: :message
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
