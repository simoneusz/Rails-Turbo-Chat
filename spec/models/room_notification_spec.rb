# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomNotification do
  describe 'validations' do
    subject { create(:room_notification) }

    it { is_expected.to validate_presence_of(:message) }
  end
end
