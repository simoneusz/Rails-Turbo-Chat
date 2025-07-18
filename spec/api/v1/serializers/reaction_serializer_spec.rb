# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::ReactionSerializer, type: :serializer do
  subject(:serializer) { described_class.new(reaction) }

  let(:reaction) { create(:reaction) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:message_id) }
    it { is_expected.to serialize_attribute(:user_id) }
    it { is_expected.to serialize_attribute(:emoji) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
  end

  describe '.to_hash' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: reaction.id,
            message_id: reaction.message_id,
            user_id: reaction.user_id,
            emoji: reaction.emoji,
            created_at: reaction.created_at,
            updated_at: reaction.updated_at
          },
          id: reaction.id.to_s,
          type: :reaction
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
