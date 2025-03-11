# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }

  before { sign_in user }

  describe 'GET #index' do
    subject(:get_index) { get :index }

    before { get_index }

    it 'returns success code' do
      expect(response).to have_http_status(:success)
    end
  end
end
