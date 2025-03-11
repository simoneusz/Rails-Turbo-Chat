# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:room) }
    it { is_expected.to have_rich_text(:content) }
  end

  describe 'callbacks' do
    subject(:message) { room.messages.create(user:, room:) }

    let(:room) { create(:room, is_private: true) }
    let(:user) { create(:user) }

    context 'when room is private and user is not a participant' do
      it 'does not allow to create a message' do
        expect { message }.not_to change(described_class, :count)
      end
    end

    context 'when room is private and user is a participant' do
      before { create(:participant, user:, room:) }

      it 'allows creating a message if user is a participant' do
        expect { message }.to change(described_class, :count).by(1)
      end
    end
  end

  describe 'methods' do
    subject!(:first_message) { create(:message, room:, user:) }

    let!(:room) { create(:room) }
    let!(:user) { create(:user) }

    context 'when calling' do
      let!(:second_message) { create(:message, room:, user:) }

      it '#next' do
        expect(first_message.next).to eq(second_message)
      end

      it '#prev' do
        expect(second_message.prev).to eq(first_message)
      end
    end
  end
end
