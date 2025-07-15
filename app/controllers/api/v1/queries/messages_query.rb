# frozen_string_literal: true

module Api
  module V1
    module Queries
      class MessagesQuery < BaseQuery
        filter_by :id
        filter_by :content, only: %i[eq]
        filter_by :created_at
      end
    end
  end
end
