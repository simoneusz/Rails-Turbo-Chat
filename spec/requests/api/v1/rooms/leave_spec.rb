# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/rooms/:id/leave' do
  include_context 'when request requires authentication'

  describe 'PATCH /api/v1/rooms/:id/leave' do
    let(:room_params) { { name: 'Test Room', is_private: false } }
    let(:room) { create(:room, room_params) }

    before do
      create(:participant, user:, room:, role: :member)
    end

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { delete "/api/v1/rooms/#{room.id}/leave", headers: headers }

        before { request }

        let(:json) { response.parsed_body['data']['relationships']['participants']['data'] }

        it 'returns 201 Created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns serialized room without participant' do
          expect(json).not_to include('id' => room.find_participant(user)&.id&.to_s, 'type' => 'participant')
        end
      end

      context 'when trying to leave peer room' do
        subject(:request) { delete "/api/v1/rooms/#{peer_room.id}/leave", headers: headers }

        before do
          create(:participant, user:, room: peer_room, role: :peer)
          create(:participant, user:, room: peer_room, role: :peer)
          request
        end

        let!(:peer_room) { create(:room) }

        it 'returns 422 unprocessable entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when unauthorized' do
      subject(:request) { delete "/api/v1/rooms/#{room.id}/join" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
