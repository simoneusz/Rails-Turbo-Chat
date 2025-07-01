# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RequestSchemas::UserUpdateSchema do
  describe '#call' do
    subject(:schema) { described_class.new.call(params) }

    context 'with valid params' do
      let(:params) do
        { first_name: 'Simone', last_name: 'Major', avatar: 'avatar_link', display_name: 'simonize' }
      end

      it 'returns a successful response' do
        expect(schema).to be_success
      end

      it 'returns blank errors' do
        expect(schema.errors).to be_empty
      end
    end

    context 'with invalid params' do
      context 'when params too short' do
        let(:params) { { first_name: 'a', last_name: 'a', display_name: 'a' } }
        let(:error_message) { 'size cannot be less than' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for first_name' do
          expect(schema.errors[:first_name].join).to include(error_message)
        end

        it 'returns an error message for last_name' do
          expect(schema.errors[:last_name].join).to include(error_message)
        end

        it 'returns an error message for display_name' do
          expect(schema.errors[:display_name].join).to include(error_message)
        end
      end

      context 'when params too long' do
        let(:params) { { first_name: 'a' * 21, last_name: 'a' * 21, display_name: 'a' * 21 } }
        let(:error_message) { 'size cannot be greater than' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for first_name' do
          expect(schema.errors[:first_name].join).to include(error_message)
        end

        it 'returns an error message for last_name' do
          expect(schema.errors[:last_name].join).to include(error_message)
        end

        it 'returns an error message for display_name' do
          expect(schema.errors[:display_name].join).to include(error_message)
        end
      end

      context 'when params have invalid type' do
        let(:params) do
          { first_name: 123, last_name: true, avatar: [], display_name: {} }
        end
        let(:error_message) { 'must be' }

        it 'returns a failed response' do
          expect(schema).not_to be_success
        end

        it 'returns an error message for first_name' do
          expect(schema.errors[:first_name].join).to include(error_message)
        end

        it 'returns an error message for last_name' do
          expect(schema.errors[:last_name].join).to include(error_message)
        end

        it 'returns an error message for avatar' do
          expect(schema.errors[:avatar].join).to include(error_message)
        end

        it 'returns an error message for display_name' do
          expect(schema.errors[:display_name].join).to include(error_message)
        end
      end
    end
  end
end
