# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/contacts' do
  include_context 'when request requires authentication'

  describe 'GET /api/v1/contacts' do
    let(:other_user) { create(:user) }

    context 'when authenticated' do
      context 'with valid params' do
        subject(:request) { get '/api/v1/contacts', headers: }

        before do
          create(:contact_ship, user:, contact: other_user, status: 'accepted')
          create(:contact_ship, user: other_user, contact: user, status: 'accepted')
          request
        end

        let(:json) { response.parsed_body }

        it 'returns 200 ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns serialized contacts' do
          expect(json['data'].map { |contact| contact['id'] }).to include(other_user.id.to_s)
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { get '/api/v1/contacts' }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
