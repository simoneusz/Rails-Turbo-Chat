# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Contacts::Delete::Serializer do
  let(:contact) { create(:contact) }
  let(:serialized_contact) { Api::V1::Serializers::ContactsSerializer.new(contact).serializable_hash }

  describe '#call' do
    subject(:serializer) { described_class.new.call(contact) }

    it 'return serialized room attributes' do
      expect(serializer).to eq(serialized_contact)
    end
  end
end
