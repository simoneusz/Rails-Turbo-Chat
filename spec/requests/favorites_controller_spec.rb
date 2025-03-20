# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:favorite) { create(:favorite, user:, room:) }

  before do
    sign_in user
  end

  describe 'POST #toggle' do
    subject(:toggle_request) { post :toggle, params: { room_id: room.id } }

    context 'when user is a participant' do
      before { create(:participant, user:, room:) }

      it 'creates a new favorite' do
        expect { toggle_request }.to change(Favorite, :count).by(1)
      end
    end

    context 'when favorite exists' do
      before do
        create(:participant, user:, room:)
        favorite
      end

      it 'removes the favorite' do
        expect { toggle_request }.to change(Favorite, :count).by(-1)
      end
    end

    context 'when user is not a participant' do
      it 'does not create or remove a favorite' do
        expect { toggle_request }.not_to change(Favorite, :count)
      end
    end
  end
end
