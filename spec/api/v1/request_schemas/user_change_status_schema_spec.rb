# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RequestSchemas::UserChangeStatusSchema do
  describe '#call' do
    subject(:schema) { described_class.new.call(params) }

    context 'with valid params' do
      let(:params) { { status: User.statuses.keys.sample } }

      it 'returns a successful response' do
        expect(schema).to be_success
      end

      it 'returns blank errors' do
        expect(schema.errors).to be_empty
      end
    end

    context 'with invalid params' do
      context 'when params have invalid type' do
        let(:params) { { status: 123 } }
        let(:error_message) { 'must be' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for status' do
          expect(schema.errors[:status].join).to include(error_message)
        end
      end

      context 'when params have invalid status' do
        let(:params) { { status: 'owner' } }
        let(:error_message) { 'must be one of' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for status' do
          expect(schema.errors[:status].join).to include(error_message)
        end
      end
    end

    context 'with missing required params' do
      let(:params) { {} }

      it 'returns a failed response' do
        expect(schema).not_to be_success
      end

      it 'returns an error message' do
        expect(schema.errors[:status].join).to include('is missing')
      end
    end
  end
end
