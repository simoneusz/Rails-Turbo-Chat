# frozen_string_literal: true

module Api
  module V1
    module Queries
      class UsersQuery < BaseQuery
        filter_by :id, only: %i[eq neq gt gte lt lte]
        filter_by :username, only: %i[eq neq]
        filter_by :first_name, only: %i[eq neq]
        filter_by :last_name, only: %i[eq neq]

        ALLOWED_SORTS = %w[id username created_at updated_at].freeze

        private

        def allowed_sorts
          ALLOWED_SORTS
        end
      end
    end
  end
end
