# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rooms::CreateRoomService do
  let(:user) { create(:user) }
  let(:valid_room_params) { { name: 'New Room', description: 'A description' } }
  let(:invalid_room_params) { { name: '', description: '' } }

  describe '#call' do
    context 'when room is successfully created' do
      it 'creates a room and adds the current user as the owner' do
        service = described_class.new(valid_room_params, user)
        result = service.call

        expect(result).to be_success
        expect(result.data).to be_a(Room)
        expect(result.data&.persisted?).to be(true)
        expect(result.data&.participants&.size).to eq(1)
        expect(result.data&.participants&.first&.user).to eq(user)
        expect(result.data&.participants&.first&.role).to eq('owner')
      end
    end

    context 'when room creation fails' do
      it 'returns an error with validation messages' do
        service = described_class.new(invalid_room_params, user)
        result = service.call

        expect(result.success?).to eq(false)
        expect(result.error_code).to eq(:new_room_invalid)
        expect(result.error_message).to include("Name can't be blank")
      end
    end
  end
end