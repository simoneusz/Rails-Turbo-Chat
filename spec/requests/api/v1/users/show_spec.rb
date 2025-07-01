# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/users/:id' do
  include_context 'when request requires authentication'

  describe 'GET /api/v1/users/:id' do
    let(:another_user) { create(:user) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { get "/api/v1/users/#{user.id}", headers: }

        before do
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized user with given first_name' do
          expect(json['data']['attributes']['first_name']).to eq(user.first_name)
        end
      end

      context 'when requesting another user' do
        subject(:request) { get "/api/v1/users/#{another_user.id}", headers: }

        before do
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized room with given name' do
          expect(json['data']['attributes']['first_name']).to eq(another_user.first_name)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { get "/api/v1/users/#{user.id}" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
