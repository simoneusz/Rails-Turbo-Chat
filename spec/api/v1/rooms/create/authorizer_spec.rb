# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rooms::Create::Authorizer do
  subject(:authorizer) { described_class.new.call(room_params, user) }

  let(:user) { create(:user) }
  let(:room_params) { { name: 'Test Room', is_private: false } }

  describe '#call' do
    context 'with valid params' do
      it 'returns true' do
        expect(authorizer).to be true
      end
    end
  end
end
