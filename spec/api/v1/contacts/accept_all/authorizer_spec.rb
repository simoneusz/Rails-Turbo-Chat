# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Contacts::AcceptAll::Authorizer do
  subject(:authorizer) { described_class.new.call }

  describe '#call' do
    it 'returns true' do
      expect(authorizer).to be true
    end
  end
end
