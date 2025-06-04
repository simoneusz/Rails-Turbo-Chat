# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RequestSchemas::RoomCreateSchema do
  describe '#call' do
    subject(:schema) { described_class.new.call(params) }

    context 'with valid params' do
      let(:params) { { name: 'Valid Room', is_private: false } }

      it 'returns a successful response' do
        expect(schema).to be_success
      end

      it 'returns blank errors' do
        expect(schema.errors).to be_empty
      end
    end

    context 'with invalid params' do
      context 'when params too short' do
        let(:params) { { name: 'a' } }
        let(:error_message) { 'size cannot be less than' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for name' do
          expect(schema.errors[:name].join).to include(error_message)
        end
      end

      context 'when params too long' do
        let(:params) { { name: 'a' * 21, topic: 'a' * 501, description: 'a' * 501 } }
        let(:error_message) { 'size cannot be greater than' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for name' do
          expect(schema.errors[:name].join).to include(error_message)
        end

        it 'returns an error message for topic' do
          expect(schema.errors[:topic].join).to include(error_message)
        end

        it 'returns an error message for description' do
          expect(schema.errors[:description].join).to include(error_message)
        end
      end

      context 'when params have invalid type' do
        let(:params) { { name: 1, is_private: 'invalid', topic: 1, description: 1 } }
        let(:error_message) { 'must be' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for name' do
          expect(schema.errors[:name].join).to include(error_message)
        end

        it 'returns an error message for is_private' do
          expect(schema.errors[:is_private].join).to include(error_message)
        end

        it 'returns an error message for topic' do
          expect(schema.errors[:topic].join).to include(error_message)
        end

        it 'returns an error message for description' do
          expect(schema.errors[:description].join).to include(error_message)
        end
      end
    end

    context 'with missing required params' do
      let(:params) { { is_private: true } }

      it 'returns a failed response' do
        expect(schema).not_to be_success
      end

      it 'returns an error message' do
        expect(schema.errors[:name].join).to include('is missing')
      end
    end
  end
end
