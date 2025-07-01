# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Contacts::AcceptAll::Validator do
  subject(:validator) { described_class.new.call }

  describe '#call' do
    it 'returns true' do
      expect(validator).to be true
    end
  end
end
