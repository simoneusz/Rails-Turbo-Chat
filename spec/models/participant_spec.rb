require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe 'validations' do
    subject { create(:participant) }

    it { should validate_presence_of(:role) }
  end
end
