# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantPolicy do
  describe 'actions' do
    subject(:room_policy) { described_class.new(user, participant) }

    let(:room) { create(:room) }
    let(:user) { create(:user) }

    shared_examples 'a policy with permitted actions' do |role, permitted_actions|
      let(:participant) { create(:participant, user:, room: room, role:) }

      it { expect(room_policy).to permit_actions(permitted_actions) }
    end

    context 'when user is the owner of the room' do
      include_examples 'a policy with permitted actions', :owner,
                       %i[change_role destroy add_participant remove_participant block_participant
                          unblock_participant chat show]
    end

    context 'when user is a moderator of the room' do
      include_examples 'a policy with permitted actions', :moderator,
                       %i[add_participant remove_participant block_participant unblock_participant chat show]
    end

    context 'when user is a member of the room' do
      include_examples 'a policy with permitted actions', :member,
                       %i[add_participant chat show]
    end

    context 'when user is a peer' do
      include_examples 'a policy with permitted actions', :peer,
                       %i[chat index show create new]
    end

    context 'when user is blocked' do
      let(:participant) { create(:participant, user:, room: room, role: :blocked) }

      it { expect(room_policy).to forbid_all_actions }
    end
  end
end
