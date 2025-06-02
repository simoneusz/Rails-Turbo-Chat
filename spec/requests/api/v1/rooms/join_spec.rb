# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/rooms/:id/join' do
  include_context 'when request requires authentication'

  describe 'PATCH /api/v1/rooms/:id/join' do
    let(:room_params) { { name: 'Test Room', is_private: false } }
    let(:room) { create(:room, room_params) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { post "/api/v1/rooms/#{room.id}/join", headers: headers }

        before { request }

        let(:json) { response.parsed_body['data']['relationships']['participants']['data'] }

        it 'returns 201 Created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns serialized room with participant' do
          expect(json).to include('id' => room.find_participant(user).id.to_s, 'type' => 'participant')
        end
      end

      context 'when trying to join private room' do
        subject(:request) { post "/api/v1/rooms/#{private_room.id}/join", headers: headers }

        before { request }

        let!(:private_room) { create(:room, is_private: true) }

        it 'returns 422 unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when user already in room' do
        subject(:request) { post "/api/v1/rooms/#{room.id}/join", headers: headers }

        before do
          create(:participant, user:, room:)
          request
        end

        it 'returns 422 unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when unauthorized' do
      subject(:request) { post "/api/v1/rooms/#{room.id}/join" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
