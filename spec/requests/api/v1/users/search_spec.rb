# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/search_users' do
  include_context 'when request requires authentication'

  describe 'GET /api/v1/search_users' do
    let(:another_user) { create(:user) }
    let(:search_params) { { q: { search: 'text' } } }

    before { user.update(username: 'text') }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { get '/api/v1/search_users', headers:, params: search_params }

        before do
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized searched user record' do
          expect(json['data'].pluck(:id)).to include(user.id.to_s)
        end
      end

      context 'when requesting non-existing user' do
        subject(:request) { get '/api/v1/search_users', headers:, params: search_params }

        let(:search_params) { { q: { search: 'ewaewaewaewa' } } }
        let(:json) { response.parsed_body }

        before do
          request
        end

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized room with given name' do
          expect(json).to eq('data' => [])
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { get '/api/v1/search_users' }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
