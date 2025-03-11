# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::CreateRoomService do
  let(:user) { create(:user) }
  let(:valid_room_params) { { name: 'New Room', is_private: false } }
  let(:invalid_room_params) { { name: '', is_private: nil } }

  describe '#call' do
    context 'when room is successfully created' do
      subject(:service) { described_class.new(valid_room_params, user).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'creates a room' do
        expect { service }.to change(Room, :count).by(1)
      end

      it 'assigns user as owner' do
        expect(service.data.participants&.first&.role).to eq('owner')
      end
    end

    context 'when room creation fails' do
      subject(:service) { described_class.new(invalid_room_params, user).call }

      it 'does not returns service success' do
        expect(service.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service.error_code).to eq(:new_room_invalid)
      end
    end
  end
end
