# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/contacts' do
  include_context 'when request requires authentication'

  describe 'POST /api/v1/contacts' do
    let(:other_user) { create(:user) }
    let(:contact_params) { { contact_id: other_user.id } }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { post '/api/v1/contacts', params: contact_params.to_json, headers: }

        before { request }

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns success message' do
          expect(json['message']).to eq('Created')
        end
      end

      context 'with invalid params' do
        subject(:request) { post '/api/v1/contacts', params: { contact_id: 'invalid' }.to_json, headers: }

        before { request }

        it 'returns 404 not found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { post '/api/v1/contacts', params: contact_params.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
