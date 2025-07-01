# frozen_string_literal: true

module Api
  module V1
    module Queries
      class RoomsQuery < BaseQuery
        ALLOWED_SORTS = %w[id name created_at updated_at].freeze
        ALLOWED_FILTERS = %w[id name created_at updated_at].freeze

        private

        def allowed_filters
          ALLOWED_FILTERS
        end

        def allowed_sorts
          ALLOWED_SORTS
        end
      end
    end
  end
end
