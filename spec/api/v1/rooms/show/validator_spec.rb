# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Show::Validator do
  describe '#call' do
    subject(:validator) { described_class.new.call }

    context 'with valid params' do
      it 'returns true' do
        expect(validator).to be true
      end
    end
  end
end
