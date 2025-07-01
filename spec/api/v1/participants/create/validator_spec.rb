# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Participants::Create::Validator do
  describe '#call' do
    subject(:validator) { described_class.new }

    let(:participant_params) { { user_id: 1 } }

    context 'with valid params' do
      it 'returns nil' do
        expect(validator.call(participant_params)).to be_nil
      end
    end

    context 'with missing required params' do
      let(:participant_params) { {} }

      it 'raises validation error' do
        expect { validator.call(participant_params) }.to raise_error(Errors::ValidationError)
      end
    end
  end
end
