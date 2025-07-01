# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH /api/v1/contacts/accept' do
  include_context 'when request requires authentication'

  describe 'PATCH /api/v1/contacts/accept' do
    let(:other_user) { create(:user) }
    let(:contact_params) { { contact_id: other_user.id } }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { patch '/api/v1/contacts/accept', params: contact_params.to_json, headers: }

        before do
          Contacts::ContactService.new(other_user, user).request_contact
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns success message' do
          expect(json['message']).to eq('Accepted')
        end
      end

      context 'with invalid params' do
        subject(:request) do
          patch '/api/v1/contacts/accept', params: { contact_id: 'invalid' }.to_json, headers:
        end

        before { request }

        it 'returns 404 not found' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { patch '/api/v1/contacts/accept', params: contact_params.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
