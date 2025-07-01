# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/rooms/:id' do
  include_context 'when request requires authentication'

  let(:room_params) { { name: 'Test Room', is_private: false } }
  let!(:room) { create(:room, room_params) }

  describe 'PATCH /api/v1/rooms' do
    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { delete "/api/v1/rooms/#{room.id}", headers: }

        before do
          create(:participant, user:, room:, role: :owner)
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 204 No Content' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with inappropriate role' do
        subject(:request) { delete "/api/v1/rooms/#{room.id}", headers: }

        before do
          create(:participant, user:, room:, role: :peer)
          request
        end

        it 'returns status 403 forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when user is not in room' do
        subject(:request) { delete "/api/v1/rooms/#{room.id}", headers: }

        before { request }

        it 'returns status 403 forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when unauthorized' do
      subject(:request) { delete '/api/v1/rooms', params: { room: {} }.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
