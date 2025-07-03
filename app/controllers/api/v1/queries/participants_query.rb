# frozen_string_literal: true

module Api
  module V1
    module Queries
      class ParticipantsQuery < BaseQuery
        filter_by :id
        filter_by :created_at
        filter_by :updated_at
        filter_by :role, only: %i[eq neq]

        sort_by :id
        sort_by :created_at
        sort_by :updated_at
        sort_by :role
      end
    end
  end
end
