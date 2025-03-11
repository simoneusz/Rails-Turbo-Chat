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
  end

  describe '#full_name' do
    subject(:user) { build(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns the full name of the user' do
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe '#request_contact' do
    subject(:other_user) { create(:user) }

    context 'when user is not contact' do
      before do
        user.request_contact(other_user)
        user.request_contact(other_user)
      end

      it 'creates a new contact request and does not create a duplicate request' do
        expect(other_user.received_contacts.where(status: :pending).size).to eq(1)
      end
    end

    context 'when user is contact' do
      before do
        user.request_contact(other_user)
        other_user.accept_contact(user)
      end

      it 'return an error' do
        expect(user.request_contact(other_user).error_code).to eq(:contact_already_exists)
      end
    end

    context 'when user is trying to add self' do
      it 'return an error' do
        expect(other_user.request_contact(other_user).error_code).to eq(:contact_add_self)
      end
    end
  end

  describe '#request_contact for existing request' do
    subject(:request_contact) { user.request_contact(other_user) }

    before { request_contact }

    it 'accept contact' do
      expect { other_user.request_contact(user) }.to change { Contact.where(status: 'accepted').count }.by(2)
    end
  end

  describe '#accept_contact' do
    subject(:other_user) { create(:user) }

    context 'when the contact exists' do
      before { other_user.request_contact(user) }

      it 'accepts a pending contact request' do
        expect { user.accept_contact(other_user) }.to change { Contact.where(status: 'accepted').count }.by(2)
      end
    end

    context 'when the contact does not exist' do
      it 'returns an error' do
        expect(user.accept_contact(other_user).error_code).to eq(:contact_doesnt_exists)
      end
    end
  end

  describe '#delete_contact' do
    subject(:other_user) { create(:user) }

    context 'when the contact exists' do
      before do
        user.request_contact(other_user)
        other_user.accept_contact(user)
      end

      it 'removes an existing contact' do
        expect { user.delete_contact(other_user) }.to change(Contact, :count).by(-2)
      end
    end

    context 'when the contact does not exists' do
      it 'returns an error' do
        expect(user.delete_contact(other_user).error_code).to eq(:contact_doesnt_exists)
      end
    end
  end

  describe '#reject_contact' do
    subject(:other_user) { create(:user) }

    context 'when contact exists' do
      before do
        user.request_contact(other_user)
      end

      it 'rejects a pending contact request' do
        expect { other_user.reject_contact(user) }.to change { Contact.where(status: 'rejected').count }.by(1)
      end
    end

    context 'when contact does not exists' do
      it 'returns an error' do
        expect(other_user.reject_contact(user).error_code).to eq(:contact_doesnt_exists)
      end
    end
  end
end
