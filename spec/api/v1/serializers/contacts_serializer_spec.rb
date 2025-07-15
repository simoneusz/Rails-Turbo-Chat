# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Serializers::ContactsSerializer, type: :serializer do
  subject(:serializer) { described_class.new(contact) }

  let(:contact) { create(:contact) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id) }
    it { is_expected.to serialize_attribute(:user_id) }
    it { is_expected.to serialize_attribute(:contact_id) }
    it { is_expected.to serialize_attribute(:created_at) }
    it { is_expected.to serialize_attribute(:updated_at) }
    it { is_expected.to serialize_attribute(:status) }
  end

  describe '.to_hash' do
    let(:serialized_attributes) do
      {
        data: {
          attributes: {
            id: contact.id,
            user_id: contact.user_id,
            contact_id: contact.contact_id,
            created_at: contact.created_at,
            updated_at: contact.updated_at,
            status: contact.status
          },
          id: contact.id.to_s,
          type: :contacts
        }
      }
    end

    it { expect(serializer.to_hash).to eq(serialized_attributes) }
  end
end
