# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validations' do
    subject { create(:contact) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:contact_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:contact).class_name('User') }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(%i[pending accepted rejected]).with_prefix }
  end
end
