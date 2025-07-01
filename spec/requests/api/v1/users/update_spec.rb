# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/users/:id' do
  include_context 'when request requires authentication'

  describe 'PATCH /api/v1/users/:id' do
    let(:update_params) { { display_name: 'changed name' } }
    let(:another_user) { create(:user) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { patch "/api/v1/users/#{user.id}", headers:, params: update_params, as: :json }

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

        it 'returns serialized user with changed display_name' do
          expect(json['data']['attributes']['display_name']).to eq(update_params[:display_name])
        end
      end

      context 'when requesting another user' do
        subject(:request) do
          patch "/api/v1/users/#{another_user.id}", headers:, params: update_params, as: :json
        end

        before do
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 403 forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with invalid params' do
        subject(:request) { patch "/api/v1/users/#{user.id}", headers:, params: update_params, as: :json }

        let(:update_params) { { test: 'field' } }
        let(:json) { response.parsed_body }

        before do
          request
        end

        it 'returns 500 internal_server_error' do
          expect(response).to have_http_status(:internal_server_error)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { patch "/api/v1/users/#{user.id}" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
