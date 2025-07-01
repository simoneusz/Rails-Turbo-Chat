# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/rooms/:room_id/messages' do
  include_context 'when request requires authentication'

  describe 'GET /api/v1/rooms/:room_id/messages' do
    let(:room) { create(:room) }
    let(:message) { create(:message, room:) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { get "/api/v1/rooms/#{room.id}/messages", headers: }

        before do
          create(:participant, user:, room:)
          message
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized messages' do
          expect(json['data'].map { |msg| msg['id'] }).to include(message.id.to_s)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { get "/api/v1/rooms/#{room.id}/messages" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
