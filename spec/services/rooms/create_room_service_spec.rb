# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::CreateRoomService do
  let!(:user) { create(:user) }
  let(:valid_room_params) { { name: 'New Room', is_private: false } }
  let(:valid_private_room_params) { { name: 'New Room', is_private: true } }
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

    context 'when room is successfully created without description and topic' do
      subject(:service) { described_class.new(valid_room_params, user).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'creates room with a nil description' do
        expect(service.data.description).to be_nil
      end

      it 'creates room with a nil topic' do
        expect(service.data.topic).to be_nil
      end
    end

    context 'when creating a self room' do
      subject(:service) { described_class.new(valid_private_room_params, user, :peer, :self_room).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'creates a room' do
        expect { service }.to change(Room, :count).by(1)
      end

      it 'assigns user as peer' do
        expect(service.data.participants&.first&.role).to eq('peer')
      end

      it 'sets room type to self_room' do
        expect(service.data.room_type).to eq('self_room')
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
