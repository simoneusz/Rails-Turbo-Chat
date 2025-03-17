# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :message
  belongs_to :user
end
