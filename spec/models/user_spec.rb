# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'validations' do
    subject { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(20) }
    it { is_expected.to validate_uniqueness_of(:username) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(6).is_at_most(255) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2).is_at_most(20) }

    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(2).is_at_most(20) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_many(:contacts).through(:contact_ships).source(:contact) }
    it { is_expected.to have_many(:inverse_contacts).through(:inverse_contact_ships).source(:user) }
    it { is_expected.to have_many(:contact_ships).dependent(:destroy) }

    it {
      is_expected.to have_many(:inverse_contact_ships) # rubocop:disable RSpec/ImplicitSubject
        .class_name('ContactShip')
        .with_foreign_key('contact_id')
        .dependent(:destroy)
        .inverse_of(:contact)
    }

    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_many(:rooms).with_foreign_key('creator_id').dependent(:destroy).inverse_of(:creator) }
  end

  describe '#full_name' do
    subject(:user) { build(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns the full name of the user' do
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe '#create_self_room' do
    subject(:user) { create(:user) }

    context 'when creation succeeds' do
      it 'creates a self room for the user' do
        expect(user.rooms.size).to eq(1)
      end

      it 'sets the room type to self_room' do
        expect(user.rooms.first.room_type).to eq('self_room')
      end

      it 'sets the room name to username_self_room' do
        expect(user.rooms.first.name).to eq("#{user.username}_self_room")
      end
    end

    context 'when creating for the second time' do
      subject(:user) { create(:user) }

      before { user.create_self_room }

      it 'does not create a new self room' do
        expect { user.create_self_room }.not_to change(Room, :count)
      end

      it 'does not create a new participant' do
        expect { user.create_self_room }.not_to change(Participant, :count)
      end
    end
  end
end
