# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Index::Authorizer do
  subject(:authorizer) { described_class.new.call }

  describe '#call' do
    context 'with valid params' do
      it 'returns true' do
        expect(authorizer).to be true
      end
    end
  end
end
