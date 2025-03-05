# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:room) { create(:room, is_private: false) }
  let(:private_room) { create(:room, is_private: true) }
  let!(:participant) { create(:participant, user: user, room: room) }
  let!(:peer_participant) { create(:participant, user: user, room: private_room, role: :peer) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:participants).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.public_rooms' do
      it 'returns only public rooms' do
        expect(Room.public_rooms).to include(room)
        expect(Room.public_rooms).not_to include(private_room)
      end
    end

    describe '.private_rooms' do
      it 'returns only private rooms' do
        expect(Room.private_rooms).to include(private_room)
        expect(Room.private_rooms).not_to include(room)
      end
    end

    describe '.all_for_user' do
      it 'returns all rooms a user participates in' do
        expect(Room.all_for_user(user)).to include(room, private_room)
      end
    end

    describe '.all_group_for_user' do
      it 'returns group rooms for user' do
        expect(Room.all_group_for_user(user)).not_to include(private_room)
      end
    end

    describe '.all_peer_rooms_for_user' do
      it 'returns only peer rooms' do
        expect(Room.all_peer_rooms_for_user(user)).to include(private_room)
      end
    end

    describe '.all_private_rooms_for_user' do
      it 'returns only private rooms excluding peer rooms' do
        expect(Room.all_private_rooms_for_user(user)).not_to include(private_room)
      end
    end
  end

  describe '#user_ids' do
    it 'returns an array of user ids' do
      room.participants.create(user: user, role: :member)
      expect(room.user_ids).to include(user.id)
    end
  end

  describe '#participant?' do
    it 'returns true if the user is a participant' do
      expect(room.participant?(user)).to be_truthy
    end

    it 'returns false if the user is not a participant' do
      expect(room.participant?(other_user)).to be_falsey
    end
  end

  describe '#user_blocked?' do
    it 'returns false if the user is not blocked' do
      expect(room.user_blocked?(user)).to be_falsey
    end
  end

  describe '#find_participant' do
    it 'returns the participant record for a user' do
      expect(room.find_participant(user)).to eq(participant)
    end

    it 'returns nil if the user is not a participant' do
      expect(room.find_participant(other_user)).to be_nil
    end
  end

  describe '#peer_room?' do
    it 'returns true if both participants are peers' do
      private_room.participants.create(user: user, role: :peer)
      expect(private_room.peer_room?).to be_truthy
    end

    it 'returns false if the room is not a peer room' do
      expect(room.peer_room?).to be_falsey
    end
  end
end
