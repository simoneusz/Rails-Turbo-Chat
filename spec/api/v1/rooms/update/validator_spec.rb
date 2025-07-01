# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Update::Validator do
  describe '#call' do
    subject(:validator) { described_class.new }

    context 'with valid params' do
      let(:room_params) { { name: 'Test Room', is_private: false } }

      it 'returns nil' do
        expect(validator.call(room_params)).to be_nil
      end
    end

    context 'with invalid params' do
      let(:room_params) { { name: 'a', topic: 'a' * 501, description: 'a' * 501 } }

      it 'raises validation error' do
        expect { validator.call(room_params) }.to raise_error(Errors::ValidationError)
      end
    end
  end
end
