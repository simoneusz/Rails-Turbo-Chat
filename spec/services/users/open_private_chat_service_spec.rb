# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OpenPrivateChatService do
  let!(:current_user) { create(:user) }
  let!(:target_user) { create(:user) }

  describe '#call' do
    context 'when private room already exists' do
      subject(:service) { described_class.new(current_user, target_user).call }

      let!(:existing_room) do
        name = "private_#{[current_user.id, target_user.id].sort.join('_')}"
        create(:room, name:, is_private: true).tap do |room|
          create(:participant, room:, user: current_user, role: :peer)
          create(:participant, room:, user: target_user, role: :peer)
        end
      end

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'returns existing room' do
        expect(service.data).to eq(existing_room)
      end
    end

    context 'when private room does not exist and is created' do
      subject(:service) { described_class.new(current_user, target_user).call }

      it 'returns service success' do
        expect(service).to be_success
      end

      it 'creates a new private room' do
        expect { service }.to change(Room, :count).by(1)
      end

      it 'adds both users' do
        expect(service.data&.participants&.pluck(:user_id)).to include(current_user.id, target_user.id)
      end

      it 'adds both users as peers' do
        expect(Room.last.participants.pluck(:role).uniq).to eq(['peer'])
      end
    end

    context 'when target user is nil' do
      subject(:service) { described_class.new(current_user, nil).call }

      it 'returns failure' do
        expect(service).not_to be_success
      end

      it 'returns error code' do
        expect(service.error_code).to eq(:user_not_found)
      end
    end

    context 'when CreatePeerRoomService fails' do
      subject(:service) { described_class.new(current_user, invalid_user).call }

      let(:invalid_user) { create(:user) }

      before do
        allow(Room).to receive(:create).and_return(Room.new)
      end

      it 'returns failure' do
        expect(service).not_to be_success
      end

      it 'returns error code from nested service' do
        expect(service.error_code).to eq(:new_room_invalid)
      end
    end
  end
end
