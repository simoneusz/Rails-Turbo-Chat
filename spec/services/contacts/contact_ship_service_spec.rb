# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contacts::ContactShipService, type: :service do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe '#request_contact' do
    subject(:service_request_contact) { described_class.new(user, other_user).request_contact }

    context 'when contact request from other user already exists' do
      before do
        create(:contact_ship, user: other_user, contact: user, status: :pending)
        service_request_contact
      end

      it 'accepts the contact' do
        aggregate_failures do
          expect(ContactShip.exists?(user: user, contact: other_user, status: :accepted)).to be true
          expect(ContactShip.exists?(user: other_user, contact: user, status: :accepted)).to be true
        end
      end
    end

    context 'when contact already exists and is accepted' do
      before do
        create(:contact_ship, user: user, contact: other_user, status: :accepted)
        create(:contact_ship, user: other_user, contact: user, status: :accepted)
        service_request_contact
      end

      it 'returns a service error' do
        expect(service_request_contact.error_code).to eq(:contact_already_exists)
      end
    end

    context 'when creating a new contact request' do
      before { service_request_contact }

      it 'returns service success' do
        expect(service_request_contact.success?).to be(true)
      end

      it 'creates a pending contact' do
        expect(ContactShip.exists?(user: user, contact: other_user, status: :pending)).to be true
      end

      it 'creates only one contact record' do
        expect(ContactShip.count).to eq(1)
      end
    end

    context 'when requesting self' do
      subject(:service_request_contact) { described_class.new(user, user).request_contact }

      before { service_request_contact }

      it 'does not returns service success' do
        expect(service_request_contact.success?).to be(false)
      end

      it 'returns service error code' do
        expect(service_request_contact.error_code).to eq(:contact_add_self)
      end
    end

    context 'when contact was previously rejected' do
      before do
        create(:contact_ship, user: other_user, contact: user, status: :rejected)
        service_request_contact
      end

      it 'changes status from rejected to pending' do
        expect(ContactShip.exists?(user: user, contact: other_user, status: :pending)).to be true
      end
    end
  end

  describe '#accept_contact' do
    subject(:service_accept_contact) { described_class.new(user, other_user).accept_contact }

    context 'when there is a pending contact request' do
      before do
        create(:contact_ship, user: other_user, contact: user, status: :pending)
        service_accept_contact
      end

      it 'accepts the contact' do
        expect(service_accept_contact.success?).to be(true)
      end

      it 'creates two contacts records' do
        aggregate_failures do
          expect(ContactShip.exists?(user: user, contact: other_user, status: :accepted)).to be true
          expect(ContactShip.exists?(user: other_user, contact: user, status: :accepted)).to be true
        end
      end
    end

    context 'when there is no pending contact request' do
      before { service_accept_contact }

      it 'returns a service error' do
        expect(service_accept_contact.error_code).to eq(:contact_doesnt_exists)
      end
    end

    context 'when reverse contact request exists' do
      before do
        create(:contact_ship, user: other_user, contact: user, status: :pending)
        service_accept_contact
      end

      it 'does not duplicate reverse contact_ship' do
        expect(ContactShip.where(user: user, contact: other_user, status: :accepted).count).to eq(1)
      end
    end
  end

  describe '#delete_contact' do
    subject(:service_delete_contact) { described_class.new(user, other_user).delete_contact }

    context 'when contact exists' do
      before do
        create(:contact_ship, user: user, contact: other_user, status: :accepted)
        create(:contact_ship, user: other_user, contact: user, status: :accepted)
        create(:room)
        create(:participant, room: Room.last, user:, role: :peer)
        create(:participant, room: Room.last, user: other_user, role: :peer)
        service_delete_contact
      end

      it 'deletes the contact' do
        aggregate_failures do
          expect(ContactShip.exists?(user: user, contact: other_user)).to be false
          expect(ContactShip.exists?(user: other_user, contact: user)).to be false
        end
      end

      it 'deletes the peer room' do
        expect(Room.peer_room_for_users(user, other_user)).to be_empty
      end
    end

    context 'when contact does not exist' do
      it 'returns result success false' do
        expect(service_delete_contact.success?).to be(false)
      end

      it 'returns an error code' do
        expect(service_delete_contact.error_code).to eq(:contact_doesnt_exists)
      end
    end
  end

  describe '#reject_contact' do
    subject(:service_reject_contact) { described_class.new(user, other_user).reject_contact }

    context 'when there is a pending contact request' do
      before do
        create(:contact_ship, user: other_user, contact: user, status: :pending)
        service_reject_contact
      end

      it 'return service success' do
        expect(service_reject_contact.success?).to be(true)
      end

      it 'rejects the contact' do
        expect(ContactShip.exists?(user: other_user, contact: user, status: :rejected)).to be true
      end

      it 'updates the contact status to rejected' do
        expect(ContactShip.exists?(user_id: other_user.id, contact_id: user.id, status: :rejected)).to be true
      end
    end

    context 'when there is no pending contact request' do
      before { service_reject_contact }

      it 'returns a service error' do
        expect(service_reject_contact.success?).to be(false)
      end

      it 'returns an error code' do
        expect(service_reject_contact.error_code).to eq(:contact_doesnt_exists)
      end
    end
  end
end
