# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactShip do
  describe 'validations' do
    subject { create(:contact_ship) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:contact_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:contact).class_name('User') }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(%i[pending accepted rejected]).with_prefix }
  end
end
