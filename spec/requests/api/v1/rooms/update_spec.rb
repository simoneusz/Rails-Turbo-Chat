# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/rooms/:id' do
  include_context 'when request requires authentication'

  let(:room_params) { { name: 'Test Room', is_private: false } }
  let!(:room) { create(:room, room_params) }

  describe 'PATCH /api/v1/rooms' do
    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { patch "/api/v1/rooms/#{room.id}", params: body, headers: }

        before do
          create(:participant, user:, room:, role: :owner)
          request
        end

        let!(:body) { { room: { name: 'New Name', description: 'New Description' } }.to_json }
        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized room with given name' do
          expect(json['data']['attributes']['name']).to eq('New Name')
        end
      end

      context 'with invalid params' do
        subject(:request) { patch "/api/v1/rooms/#{room.id}", params: body, headers: }

        before do
          create(:participant, user:, room:, role: :owner)
          request
        end

        let!(:body) { { room: { name: 'a' } }.to_json }
        let(:json) { response.parsed_body }

        it 'returns 422 Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns validation errors' do
          expect(json['errors']['message']).to include('size cannot be less than 3')
        end
      end

      context 'with inappropriate role' do
        subject(:request) { patch "/api/v1/rooms/#{room.id}", params: body, headers: }

        before do
          create(:participant, user:, room:, role: :peer)
          request
        end

        let!(:body) { { room: { name: 'New Name', description: 'New Description' } }.to_json }

        it 'returns status 403 forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when unauthorized' do
      subject(:request) { patch "/api/v1/rooms/#{room.id}", params: { room: {} }.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
