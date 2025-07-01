# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/notifications' do
  include_context 'when request requires authentication'

  describe 'GET /api/v1/notifications' do
    let(:notification) { create(:notification, receiver: user) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { get '/api/v1/notifications', headers: }

        before do
          notification
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { get '/api/v1/notifications' }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
