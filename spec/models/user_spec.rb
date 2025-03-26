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
    it { is_expected.to have_many(:sent_contacts).class_name('Contact').dependent(:destroy) }

    it {
      is_expected # rubocop:disable RSpec/ImplicitSubject
        .to have_many(:received_contacts).class_name('Contact').with_foreign_key('contact_id').dependent(:destroy)
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
end
