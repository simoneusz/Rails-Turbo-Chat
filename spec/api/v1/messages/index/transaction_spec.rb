# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Messages::Index::Transaction do
  describe '#call' do
    subject(:transaction) { described_class.new.call(params, room, current_user) }

    let(:room) { create(:room) }
    let(:params_hash) { { filter: { id: room.reload.messages.first.id } } }
    let(:params) { ActionController::Parameters.new(params_hash) }
    let(:current_user) { create(:user) }

    context 'with valid params' do
      before do
        create(:participant, user: current_user, room:)
        create_list(:message, 3, room:)
      end

      it 'returns a successful response with status :ok' do
        expect(transaction[:status]).to eq(:ok)
      end

      it 'returns serialized messages' do
        expect(
          transaction[:data].first
        ).to eq(Api::V1::Messages::Index::Serializer.new.call(room.reload.messages)[:data].first)
      end
    end
  end
end
