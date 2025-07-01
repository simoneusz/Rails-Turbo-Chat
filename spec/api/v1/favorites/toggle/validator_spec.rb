# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Favorites::Toggle::Validator do
  describe '#call' do
    subject(:validator) { described_class.new.call(favorite_params) }

    let(:favorite_params) { { room_id: 1 } }

    context 'with valid params' do
      it 'returns nil' do
        expect(validator).to be_nil
      end
    end

    context 'with invalid params' do
      let(:favorite_params) { { room_id: 'invalid' } }

      it 'raises validation error' do
        expect { validator }.to raise_error(Errors::ValidationError)
      end
    end
  end
end
