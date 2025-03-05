# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
    it { should have_rich_text(:content) }
  end

  describe 'callbacks' do
    let(:room) { create(:room, is_private: true) }
    let(:user) { create(:user) }

    context 'when room is private' do
      subject { room.messages.create(user: user, room: room) }
      it 'does not allow creating a message if user is not a participant' do
        expect { subject }.to change(Message, :count).by(0)
      end

      it 'allows creating a message if user is a participant' do
        create(:participant, user: user, room: room)
        expect { subject }.to change(Message, :count).by(1)
      end
    end
  end

  describe '#next' do
    it 'returns the next message in the room' do
      room = create(:room)
      user = create(:user)
      message1 = create(:message, room: room, user: user)
      message2 = create(:message, room: room, user: user)

      expect(message1.next).to eq(message2)
    end
  end

  describe '#prev' do
    it 'returns the previous message in the room' do
      room = create(:room)
      user = create(:user)
      message1 = create(:message, room: room, user: user)
      message2 = create(:message, room: room, user: user)

      expect(message2.prev).to eq(message1)
    end
  end
end
