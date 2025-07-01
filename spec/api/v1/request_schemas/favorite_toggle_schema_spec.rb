# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RequestSchemas::FavoriteToggleSchema do
  describe '#call' do
    subject(:schema) { described_class.new.call(params) }

    context 'with valid params' do
      let(:params) { { room_id: 1 } }

      it 'returns a successful response' do
        expect(schema).to be_success
      end

      it 'returns blank errors' do
        expect(schema.errors).to be_empty
      end
    end

    context 'with invalid params' do
      context 'when params have invalid type' do
        let(:params) { { room_id: 'invalid' } }
        let(:error_message) { 'must be' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for name' do
          expect(schema.errors[:room_id].join).to include(error_message)
        end
      end
    end

    context 'with missing required params' do
      let(:params) { {} }

      it 'returns a failed response' do
        expect(schema).not_to be_success
      end

      it 'returns an error message' do
        expect(schema.errors[:room_id].join).to include('is missing')
      end
    end
  end
end
