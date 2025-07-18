# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/rooms/:room_id/participants' do
  include_context 'when request requires authentication'

  describe 'GET /api/v1/rooms/:room_id/participants' do
    let(:room) { create(:room) }
    let(:participant) { create(:participant, user:, room:) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { get "/api/v1/rooms/#{room.id}/participants", headers: }

        before do
          participant
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized participants' do
          expect(json['data'].map { |p| p['id'] }).to include(participant.id.to_s)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { get "/api/v1/rooms/#{room.id}/participants" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
