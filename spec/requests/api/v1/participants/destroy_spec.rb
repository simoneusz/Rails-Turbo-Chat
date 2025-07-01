# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/rooms/:room_id/participants/:id' do
  include_context 'when request requires authentication'

  describe 'DELETE /api/v1/rooms/:room_id/participants/:id' do
    let(:room) { create(:room) }
    let(:other_user) { create(:user) }
    let(:participant_to_remove) { create(:participant, user: other_user, room:) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) do
          delete "/api/v1/rooms/#{room.id}/participants/#{participant_to_remove.id}",
                 params: { participant_id: participant_to_remove.id }.to_json, headers:
        end

        before do
          create(:participant, user:, room:, role: :owner)
          request
        end

        it 'returns 204 No Content' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when user is not owner of room' do
        subject(:request) do
          delete "/api/v1/rooms/#{room.id}/participants/#{participant_to_remove.id}",
                 params: { participant_id: participant_to_remove.id }.to_json, headers:
        end

        before do
          create(:participant, user:, room:, role: :member)
          request
        end

        it 'returns 403 Forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when participant does not exist' do
        subject(:request) do
          delete "/api/v1/rooms/#{room.id}/participants/999999", params: { participant_id: 999_999 }.to_json,
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
      subject(:request) do
        delete "/api/v1/rooms/#{room.id}/participants/#{participant_to_remove.id}",
               params: { participant_id: participant_to_remove.id }.to_json
      end

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
