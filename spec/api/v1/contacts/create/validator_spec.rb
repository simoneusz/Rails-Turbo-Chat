# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Contacts::Create::Validator do
  describe '#call' do
    subject(:validator) { described_class.new.call(contact_params) }

    let(:contact_params) { { contact_id: 1 } }

    context 'with valid params' do
      it 'returns nil' do
        expect(validator).to be_nil
      end
    end

    context 'with invalid params' do
      let(:contact_params) { { contact_id: 'no' } }

      it 'raises validation error' do
        expect { validator }.to raise_error(Errors::ValidationError)
      end
    end
  end
end
