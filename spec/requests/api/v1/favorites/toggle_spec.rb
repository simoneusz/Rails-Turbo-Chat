# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/favorites/toggle' do
  include_context 'when request requires authentication'

  describe 'POST /api/v1/favorites/toggle' do
    let(:room) { create(:room) }
    let(:favorite_params) { { favorite: { room_id: room.id } } }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { post '/api/v1/favorites/toggle', params: favorite_params.to_json, headers: }

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
      end

      context 'when favorite already exists' do
        subject(:request) { post '/api/v1/favorites/toggle', params: favorite_params.to_json, headers: }

        before do
          create(:participant, user:, room:)
          create(:favorite, user:, room:)
          request
        end

        it 'returns 204 No Content' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when user is not participant of room' do
        subject(:request) { post '/api/v1/favorites/toggle', params: favorite_params.to_json, headers: }

        before { request }

        it 'returns 403 Forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with invalid params' do
        subject(:request) do
          post '/api/v1/favorites/toggle', params: { favorite: { room_id: 'invalid' } }.to_json, headers:
        end

        before { request }

        it 'returns 404 not found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { post '/api/v1/favorites/toggle', params: favorite_params.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
