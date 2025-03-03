# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }

  before { sign_in user }
end
