# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/rooms/:room_id/participants/toggle_notifications' do
  include_context 'when request requires authentication'

  describe 'PATCH /api/v1/rooms/:room_id/participants/toggle_notifications' do
    let(:room) { create(:room) }
    let!(:participant) { create(:participant, user:, room:) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) do
          patch "/api/v1/rooms/#{room.id}/participants/#{participant.id}/toggle_notifications", headers:
        end

        before do
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns success message' do
          expect(json['message']).to eq('Notifications toggled')
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { patch "/api/v1/rooms/#{room.id}/participants/#{participant.id}/toggle_notifications" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
