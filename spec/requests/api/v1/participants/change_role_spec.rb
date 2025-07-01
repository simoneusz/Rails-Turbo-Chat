# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/rooms/:room_id/participants/change_role' do
  include_context 'when request requires authentication'

  describe 'POST /api/v1/rooms/:room_id/participants/change_role' do
    let(:room) { create(:room) }
    let(:other_user) { create(:user) }
    let!(:participant_to_change) { create(:participant, user: other_user, room:, role: :member) }
    let!(:change_role_params) { { participant: { role: 'moderator' }, participant_id: participant_to_change.id } }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/participants/#{participant_to_change.id}/change_role",
               params: change_role_params.to_json, headers:
        end

        before do
          create(:participant, user:, room:, role: :owner)
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns success message' do
          expect(json['message']).to eq('Role changed')
        end
      end

      context 'when user is not owner of room' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/participants/#{participant_to_change.id}/change_role",
               params: change_role_params.to_json,
               headers:
        end

        before do
          create(:participant, user:, room:, role: :member)
          request
        end

        it 'returns 403 Forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with invalid params' do
        subject(:request) do
          post "/api/v1/rooms/#{room.id}/participants/#{participant_to_change.id}/change_role",
               params: { participant: { role: 'invalid_role' }, participant_id: participant_to_change.id }.to_json,
               headers:
        end

        before do
          create(:participant, user:, room:, role: :owner)
          request
        end

        it 'returns 422 Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { post "/api/v1/rooms/#{room.id}/participants/change_role", params: change_role_params.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
