# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    subject { create(:user) }
    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(20) }
    it { should validate_uniqueness_of(:username) }

    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_least(6).is_at_most(255) }

    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_least(2).is_at_most(20) }

    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_least(2).is_at_most(20) }
  end

  describe 'associations' do
    it { should have_many(:messages) }
    it { should have_many(:sent_contacts).class_name('Contact').with_foreign_key('user_id').dependent(:destroy) }
    it { should have_many(:received_contacts).class_name('Contact').with_foreign_key('contact_id').dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe '#full_name' do
    subject { build(:user, first_name: 'John', last_name: 'Doe') }
    it 'returns the full name of the user' do
      expect(subject.full_name).to eq('John Doe')
    end
  end

  describe '#request_contact' do
    subject { create(:user) }

    it 'creates a new contact request' do
      expect { user.request_contact(subject) }.to change(Contact, :count).by(1)
    end

    it 'does not create a duplicate request' do
      user.request_contact(subject)
      expect { user.request_contact(subject) }.not_to change(Contact, :count)
    end

    it 'accepts contact if a request already exists from the other user' do
      subject.request_contact(user)
      expect { user.request_contact(subject) }.to change { Contact.where(status: 'accepted').count }.by(2)
    end
  end

  describe '#accept_contact' do
    subject { create(:user) }

    it 'accepts a pending contact request' do
      subject.request_contact(user)
      expect { user.accept_contact(subject) }.to change { Contact.where(status: 'accepted').count }.by(2)
    end
  end

  describe '#delete_contact' do
    subject { create(:user) }

    it 'removes an existing contact' do
      user.request_contact(subject)
      subject.accept_contact(user)
      expect { user.delete_contact(subject) }.to change(Contact, :count).by(-2)
    end
  end

  describe '#reject_contact' do
    subject { create(:user) }

    it 'rejects a pending contact request' do
      user.request_contact(subject)
      expect { subject.reject_contact(user) }.to change { Contact.where(status: 'rejected').count }.by(1)
    end
  end
end
