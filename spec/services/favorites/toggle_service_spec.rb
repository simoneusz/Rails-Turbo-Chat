# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorites::ToggleService do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let!(:favorite) { create(:favorite, user:, room:) }

  describe '#toggle_favorite' do
    context 'when favorite does exist' do
      subject(:service) { described_class.new(favorite, room, user).toggle_favorite }

      before { create(:participant, room:, user:, role: :member) }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'deletes favorite' do
        expect { service }.to change(Favorite, :count).by(-1)
      end

      it 'returns nil in data' do
        expect(service.data).to be_nil
      end
    end

    context 'when favorite does not exist' do
      subject(:service) { described_class.new(nil, room, user).toggle_favorite }

      before { create(:participant, room:, user:, role: :member) }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'creates favorite' do
        expect { service }.to change(Favorite, :count).by(1)
      end

      it 'returns favorite in data' do
        expect(service.data).to eq(Favorite.last)
      end
    end

    context 'when user is not a participant' do
      subject(:service) { described_class.new(nil, room, user).toggle_favorite }

      it 'does not returns service success' do
        expect(service).not_to be_success
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:not_a_participant)
      end
    end
  end
end
