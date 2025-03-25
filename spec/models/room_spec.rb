# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:room) { create(:room, is_private: false) }
  let!(:private_room) { create(:room, is_private: true) }
  let!(:participant) { create(:participant, user:, room:, role: :owner) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:creator) }

    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:participants).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.public_rooms' do
      subject(:public_rooms) { described_class.public_rooms }

      it 'returns only public rooms' do
        expect(public_rooms).to contain_exactly(room)
      end

      it 'does not returns private rooms' do
        expect(public_rooms).not_to include(private_room)
      end
    end

    describe '.private_rooms when user has private rooms' do
      subject(:private_rooms) { described_class.private_rooms }

      it 'returns private rooms' do
        expect(private_rooms).to include(private_room)
      end

      it 'do not returns public rooms' do
        expect(private_rooms).not_to contain_exactly(room)
      end
    end

    describe '.all_for_user' do
      subject(:all_for_user) { described_class.all_for_user(user) }

      it 'returns all rooms a user participates in' do
        expect(all_for_user).to include(room)
      end
    end

    describe '.all_group_for_user' do
      subject(:all_group_for_user) { described_class.all_group_for_user(user) }

      it 'returns group rooms for user' do
        expect(all_group_for_user).not_to contain_exactly(private_room)
      end
    end

    describe '.all_peer_rooms_for_user' do
      subject(:all_peer_rooms_for_user) { described_class.all_peer_rooms_for_user(user) }

      before { create(:participant, user:, room: private_room, role: :peer) }

      it 'returns only peer rooms' do
        expect(all_peer_rooms_for_user).to include(private_room)
      end
    end

    describe '.all_private_rooms_for_user' do
      subject(:all_private_rooms_for_user) { described_class.all_private_rooms_for_user(user) }

      it 'returns only private rooms excluding peer rooms' do
        expect(all_private_rooms_for_user).not_to contain_exactly(private_room)
      end
    end
  end

  describe '#user_ids' do
    context 'when room have users' do
      subject(:user_ids) { room.reload.user_ids }

      it 'returns an array of user ids' do
        expect(user_ids).to include(user.id)
      end
    end

    context 'when room does not have users' do
      subject(:user_ids) { create(:room).reload.user_ids }

      it 'returns an empty array' do
        expect(user_ids).to be_empty
      end
    end
  end

  describe '#participant?' do
    subject(:room) { create(:room, is_private: false) }

    context 'when user is a participant' do
      it 'returns true' do
        expect(room).to be_participant(user)
      end
    end

    context 'when user is not a participant' do
      it 'returns false' do
        expect(room).not_to be_participant(other_user)
      end
    end
  end

  describe '#user_blocked?' do
    subject(:room) { create(:room, is_private: false) }

    context 'when user is not blocked' do
      it 'returns false if the user is not blocked' do
        expect(room).not_to be_user_blocked(user)
      end
    end

    context 'when user is blocked' do
      before { create(:participant, room:, user:, role: :blocked) }

      it 'returns true' do
        expect(room).to be_user_blocked(user)
      end
    end
  end

  describe '#find_participant' do
    subject(:room) { create(:room) }

    context 'when user is a participant' do
      it 'returns the participant record for a user' do
        expect(room.find_participant(user)).to eq(participant)
      end
    end

    context 'when user is not a participant' do
      it 'returns nil if the user is not a participant' do
        expect(room.find_participant(other_user)).to be_nil
      end
    end
  end

  describe '#peer_room?' do
    context 'when the users are peer in the private room' do
      subject(:private_room) { create(:room, is_private: true) }

      before do
        private_room.participants.create(user:, role: :peer)
        private_room.participants.create(user:, role: :peer)
      end

      it 'returns true' do
        expect(private_room).to be_peer_room
      end
    end

    context 'when the users are not a peer in the private room' do
      subject(:room) { create(:room, is_private: true) }

      before { room.participants.create(user:, role: :owner) }

      it 'returns false' do
        expect(room).not_to be_peer_room
      end
    end
  end
end
