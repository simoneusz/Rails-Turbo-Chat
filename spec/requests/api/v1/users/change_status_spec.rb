# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/users/:id/change_status' do
  include_context 'when request requires authentication'

  describe 'PATCH /api/v1/users/:id' do
    let(:change_status_params) { { status: 'offline' } }
    let(:another_user) { create(:user) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) do
          patch "/api/v1/users/#{user.id}/change_status", headers:, params: change_status_params, as: :json
        end

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

        it 'returns serialized user with changed status' do
          expect(json['data']['attributes']['status']).to eq(change_status_params[:status])
        end
      end

      context 'when requesting another user' do
        subject(:request) do
          patch "/api/v1/users/#{another_user.id}/change_status",
                headers:,
                params: change_status_params,
                as: :json
        end

        before do
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 403 forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { patch "/api/v1/users/#{user.id}/change_status" }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
