# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/rooms/:room_id/participants' do
  include_context 'when request requires authentication'

  describe 'POST /api/v1/rooms/:room_id/participants' do
    let(:room) { create(:room) }
    let(:other_user) { create(:user) }
    let(:participant_params) { { participant: { user_id: other_user.id } } }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/participants", params: participant_params.to_json, headers:
        end

        before do
          create(:participant, user:, room:, role: :owner)
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

      context 'with invalid params' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/participants", params: { participant: { user_id: 'invalid' } }.to_json,
                                                        headers:
        end

        before do
          create(:participant, user:, room:, role: :owner)
          request
        end

        it 'returns 404 Not Found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { post "/api/v1/rooms/#{room.id}/participants", params: participant_params.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
