# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/notifications/:id/mark_as_read' do
  include_context 'when request requires authentication'

  describe 'PATCH /api/v1/notifications/:id/mark_as_read' do
    let!(:notification) { create(:user_notification, receiver: user) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { patch "/api/v1/notifications/#{notification.id}/mark_as_read", headers: }

        before { request }

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when notification does not exist' do
        subject(:request) { patch '/api/v1/notifications/999999/mark_as_read', headers: }

        before { request }

        it 'returns 404 Not Found' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when notification belongs to another user' do
        subject(:request) { patch "/api/v1/notifications/#{another_notification.id}/mark_as_read", headers: }

        let(:another_user) { create(:user) }
        let(:another_notification) { create(:notification, receiver: another_user) }

        before { request }

        it 'returns 404 Not Found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { patch "/api/v1/notifications/#{notification.id}/mark_as_read" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
