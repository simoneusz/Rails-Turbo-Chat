# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/contacts/accept_all' do
  include_context 'when request requires authentication'

  describe 'POST /api/v1/contacts/accept_all' do
    let(:other_user) { create(:user) }
    let(:third_user) { create(:user) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { post '/api/v1/contacts/accept_all', headers: }

        before do
          Contacts::ContactService.new(other_user, user).request_contact
          Contacts::ContactService.new(third_user, user).request_contact
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
    end

    context 'when not authenticated' do
      subject(:request) { post '/api/v1/contacts/accept_all' }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
