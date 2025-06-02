# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/rooms' do
  let(:user) { create(:user) }
  let(:auth_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  def headers
    {
      'Authorization' => "Bearer #{auth_token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  describe 'POST /api/v1/rooms' do
    context 'when authenticated' do
      let(:room_params) { { name: 'Test Room', is_private: false } }
      let(:invalid_params) { { name: nil, is_private: nil } }

      context 'with valid params' do
        subject(:request) { post '/api/v1/rooms', params: { room: room_params }.to_json, headers: headers }

        before { request }

        let(:json) { response.parsed_body }

        it 'returns 201 Created' do
          expect(response).to have_http_status(:created)
        end

        it 'returns serialized room with given name' do
          expect(json['data']['attributes']['name']).to eq(room_params[:name])
        end
      end

      context 'with invalid params' do
        subject(:request) { post '/api/v1/rooms', params: { room: invalid_params }.to_json, headers: headers }

        before { request }

        let(:json) { response.parsed_body }

        it 'returns 422 Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns validation errors' do
          expect(json['errors']['message']).to include('must be filled')
        end
      end
    end

    context 'when not authenticated' do
      subject(:request) { post '/api/v1/rooms', params: { room: {} }.to_json }

      before { request }

      it 'returns 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
