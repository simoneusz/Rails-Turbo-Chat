# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RequestSchemas::MessageSchema do
  describe '#call' do
    subject(:schema) { described_class.new.call(params) }

    context 'with valid params' do
      let(:params) { { content: 'message content', parent_message_id: 1, replied: true } }

      it 'returns a successful response' do
        expect(schema).to be_success
      end

      it 'returns blank errors' do
        expect(schema.errors).to be_empty
      end
    end

    context 'with invalid params' do
      context 'when params have invalid type' do
        let(:params) { { content: 1, parent_message_id: 'weird', replied: 123 } }
        let(:error_message) { 'must be' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for content' do
          expect(schema.errors[:content].join).to include(error_message)
        end

        it 'returns an error message for parent_message_id' do
          expect(schema.errors[:parent_message_id].join).to include(error_message)
        end

        it 'returns an error message for replied' do
          expect(schema.errors[:replied].join).to include(error_message)
        end
      end
    end

    context 'with missing required params' do
      let(:params) { { parent_message_id: 'weird', replied: 'yes' } }

      it 'returns a failed response' do
        expect(schema).not_to be_success
      end

      it 'returns an error message' do
        expect(schema.errors[:content].join).to include('is missing')
      end
    end
  end
end
