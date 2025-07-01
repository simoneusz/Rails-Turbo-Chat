# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::Destroy::Serializer do
  describe '#call' do
    subject(:serializer) { described_class.new.call }

    it 'return serialized room attributes' do
      expect(serializer).to be_nil
    end
  end
end
