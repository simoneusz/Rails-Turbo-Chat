# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomPolicy do
  let(:room) { create(:room) }
  let(:user) { create(:user) }
  let(:participant) { create(:participant, user:, room: room, role: :owner) }

  describe 'actions' do
    subject(:room_policy) { described_class.new(user, room) }

    let(:room) { create(:room) }
    let(:user) { create(:user) }
    let(:participant) { create(:participant, user:, room: room, role: :owner) }

    context 'when user is the owner of the room' do
      it { is_expected.to forbid_actions(%i[create edit index new show update]) }
    end
  end
end
