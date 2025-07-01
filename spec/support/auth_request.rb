# frozen_string_literal: true

RSpec.shared_context 'when request requires authentication' do
  let(:user) { create(:user) }
  let(:auth_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  def headers
    {
      'Authorization' => "Bearer #{auth_token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end
end
