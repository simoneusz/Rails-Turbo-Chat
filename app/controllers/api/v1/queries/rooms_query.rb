# frozen_string_literal: true

module Api
  module V1
    module Queries
      class RoomsQuery < BaseQuery
        filter_by :id, only: %i[eq neq gt gte lt lte]
        filter_by :name, only: %i[eq]
        filter_by :created_at, only: %i[eq neq gt lt gte lte]
        filter_by :updated_at, only: %i[eq neq gt lt gte lte]

        private

        def allowed_sorts
          %w[id name created_at updated_at]
        end
      end
    end
  end
end
