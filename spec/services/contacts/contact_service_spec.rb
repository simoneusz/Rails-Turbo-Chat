# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contacts::ContactService, type: :service do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe '#request_contact' do
    context 'when requesting self' do
      subject { described_class.new(user, user).request_contact }
      it 'returns an error' do
        expect(subject).not_to be_success
        expect(subject.error_code).to eq(:contact_add_self)
      end
    end

    context 'when contact request from other user already exists' do
      subject { described_class.new(user, other_user).request_contact }
      it 'accepts the contact' do
        create(:contact, user: other_user, contact: user, status: :pending)
        expect(subject).to be_success
        expect(Contact.exists?(user: user, contact: other_user, status: :accepted)).to be true
        expect(Contact.exists?(user: other_user, contact: user, status: :accepted)).to be true
      end
    end

    context 'when contact already exists and is accepted' do
      subject { described_class.new(user, other_user).request_contact }
      it 'returns an error' do
        create(:contact, user: user, contact: other_user, status: :accepted)

        expect(subject).not_to be_success
        expect(subject.error_code).to eq(:contact_already_exists)
      end
    end

    context 'when creating a new contact request' do
      subject { described_class.new(user, other_user).request_contact }
      it 'creates a pending contact' do
        expect(subject).to be_success
        expect(Contact.exists?(user: user, contact: other_user, status: :pending)).to be true
      end
    end
  end

  describe '#accept_contact' do
    subject { described_class.new(user, other_user).accept_contact }
    context 'when there is a pending contact request' do
      it 'accepts the contact' do
        create(:contact, user: other_user, contact: user, status: :pending)

        expect(subject).to be_success
        expect(Contact.exists?(user: user, contact: other_user, status: :accepted)).to be true
        expect(Contact.exists?(user: other_user, contact: user, status: :accepted)).to be true
      end
    end

    context 'when there is no pending contact request' do
      it 'returns an error' do
        expect(subject).not_to be_success
        expect(subject.error_code).to eq(:contact_doesnt_exists)
      end
    end
  end

  describe '#delete_contact' do
    subject { described_class.new(user, other_user).delete_contact }
    context 'when contact exists' do
      it 'deletes the contact' do
        create(:contact, user: user, contact: other_user, status: :accepted)
        create(:contact, user: other_user, contact: user, status: :accepted)

        expect(subject).to be_success
        expect(Contact.exists?(user: user, contact: other_user)).to be false
        expect(Contact.exists?(user: other_user, contact: user)).to be false
      end
    end

    context 'when contact does not exist' do
      it 'returns success without error' do
        expect(subject).to be_success
      end
    end
  end

  describe '#reject_contact' do
    subject { described_class.new(user, other_user).reject_contact }
    context 'when there is a pending contact request' do
      it 'rejects the contact' do
        create(:contact, user: other_user, contact: user, status: :pending)

        expect(subject).to be_success
        expect(Contact.exists?(user: other_user, contact: user, status: :rejected)).to be true
      end
    end

    context 'when there is no pending contact request' do
      it 'returns an error' do
        expect(subject).not_to be_success
        expect(subject.error_code).to eq(:contact_doesnt_exists)
      end
    end
  end
end
