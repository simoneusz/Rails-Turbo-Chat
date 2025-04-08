# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :receiver, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  scope :unviewed, -> { where(viewed: false) }
end
