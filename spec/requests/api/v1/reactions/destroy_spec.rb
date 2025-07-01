# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/rooms/:room_id/messages/:message_id/reactions' do
  include_context 'when request requires authentication'

  describe 'DELETE /api/v1/rooms/:room_id/messages/:message_id/reactions' do
    let(:room) { create(:room) }
    let(:message) { create(:message, room:, user:) }
    let(:reaction_params) { { emoji: ')' } }

    context 'when authenticated' do
      before { create(:participant, user:, room:, role: :member) }

      context 'with valid params' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/messages/#{message.id}/reactions",
               params: { reaction: reaction_params }.to_json,
               headers:
        end

        before { request }

        let(:json) { response.parsed_body }

        it 'returns 201 Created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns serialized message with correct id' do
          expect(json['data']['id']).to eq(message.id.to_s)
        end
      end

      context 'with invalid params' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/messages/#{message.id}/reactions", params: { room: {} }.to_json,
                                                                            headers:
        end

        before { request }

        let(:json) { response.parsed_body }

        it 'returns 500 internal_server_error' do
          expect(response).to have_http_status(:internal_server_error)
        end

        it 'returns validation errors' do
          expect(json['errors']['message']).to include('is missing')
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) do
        post "/api/v1/rooms/#{room.id}/messages/#{message.id}/reactions", params: { room: {} }.to_json
      end

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
