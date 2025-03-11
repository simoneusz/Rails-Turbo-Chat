# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participant do
  describe 'validations' do
    subject { create(:participant) }

    it { is_expected.to validate_presence_of(:role) }
  end
end
