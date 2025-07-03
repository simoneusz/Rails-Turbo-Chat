# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/rooms/:room_id/messages' do
  include_context 'when request requires authentication'

  describe 'POST /api/v1/rooms/:room_id/messages' do
    let(:room) { create(:room) }
    let(:message_params) { { message: { content: 'Test message content' } } }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { post "/api/v1/rooms/#{room.id}/messages", params: message_params.to_json, headers: }

        before do
          create(:participant, user:, room:)
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 201 Created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns success message' do
          expect(json['message']).to eq('Created')
        end

        it 'returns serialized message with content' do
          expect(json['data']['attributes']['content']).to eq('Test message content')
        end
      end

      context 'when user is not participant of room' do
        subject(:request) { post "/api/v1/rooms/#{room.id}/messages", params: message_params.to_json, headers: }

        before { request }

        it 'returns 403 Forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with invalid params' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/messages", params: { message: { content: nil } }.to_json, headers:
        end

        before do
          create(:participant, user:, room:)
          request
        end

        it 'returns 422 Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { post "/api/v1/rooms/#{room.id}/messages", params: message_params.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
