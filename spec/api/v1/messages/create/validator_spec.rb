# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Messages::Create::Validator do
  describe '#call' do
    subject(:validator) { described_class.new }

    let(:messages_params) { { content: 'message content', parent_message_id: 1, replied: true } }

    context 'with valid params' do
      it 'returns nil' do
        expect(validator.call(messages_params)).to be_nil
      end
    end

    context 'with invalid params' do
      let(:messages_params) { { content: 123, parent_message_id: 'weird', replied: 'yes' } }

      it 'raises validation error' do
        expect { validator.call(messages_params) }.to raise_error(Errors::ValidationError)
      end
    end

    context 'with missing required params' do
      let(:messages_params) { {} }

      it 'raises validation error' do
        expect { validator.call(messages_params) }.to raise_error(Errors::ValidationError)
      end
    end
  end
end
