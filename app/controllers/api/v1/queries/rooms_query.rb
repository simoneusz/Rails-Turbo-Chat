# frozen_string_literal: true

module Api
  module V1
    module Queries
      class RoomsQuery < BaseQuery
        filter_by :id
        filter_by :name, only: %i[eq]
        filter_by :created_at
        filter_by :updated_at

        sort_by :id
        sort_by :name
        sort_by :created_at
        sort_by :updated_at
      end
    end
  end
end
