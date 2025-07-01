# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::Index::Validator do
  describe '#call' do
    subject(:validator) { described_class.new }

    context 'with valid params' do
      it 'returns nil' do
        expect(validator.call).to be(true)
      end
    end
  end
end
