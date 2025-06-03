# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/rooms/:id' do
  include_context 'when request requires authentication'

  describe 'GET /api/v1/rooms' do
    let(:room_params) { { name: 'Test Room', is_private: false } }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { get "/api/v1/rooms/#{room.id}", headers: headers }

        before do
          request
        end

        let!(:room) { create(:room, room_params) }
        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized room with given name' do
          expect(json['data']['attributes']['name']).to eq(room.name)
        end
      end

      context 'with inappropriate role' do
        subject(:request) { get "/api/v1/rooms/#{room.id}", headers: headers }

        before do
          request
        end

        let(:room_params) { { name: 'Test Room', is_private: true } }
        let!(:room) { create(:room, room_params) }

        it 'returns 403 Forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { get '/api/v1/rooms', params: { room: {} }.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
