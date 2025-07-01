# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/rooms/:room_id/messages/:id' do
  include_context 'when request requires authentication'

  describe 'DELETE /api/v1/rooms/:room_id/messages/:id' do
    let(:room) { create(:room) }
    let(:message) { create(:message, room:, user:) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { delete "/api/v1/rooms/#{room.id}/messages/#{message.id}", headers: }

        before do
          create(:participant, user:, room:)
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 204 no_content' do
          expect(response).to have_http_status(:no_content)
        end

        it 'returns empty response' do
          expect(json).to be_empty
        end
      end

      context 'when user is not participant of room' do
        subject(:request) { delete "/api/v1/rooms/#{room.id}/messages/#{message.id}", headers: }

        before { request }

        it 'returns 403 Forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when message does not exist' do
        subject(:request) { delete "/api/v1/rooms/#{room.id}/messages/999999", headers: }

        before do
          create(:participant, user:, room:)
          request
        end

        it 'returns 404 Not Found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { delete "/api/v1/rooms/#{room.id}/messages/#{message.id}" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
