require 'rails_helper'

RSpec.describe RoomNotification, type: :model do
  describe 'validations' do
    subject { create(:room_notification) }

    it { should validate_presence_of(:message) }
  end
end
