# frozen_string_literal: true

# Query object for filtering, sorting and paginating records

module Api
  module V1
    module Queries
      # Base query object for filtering, sorting and paginating records
      class BaseQuery
        include Pagy::Backend

        DEFAULT_PER_PAGE = 20
        MAX_PER_PAGE = 100

        def initialize(scope, params = {})
          @scope = scope
          @params = params
        end

        def call
          filter
          sort
          paginate
          [@pagy, @records]
        end

        private

        def allowed_sorts
          []
        end

        def allowed_filters
          []
        end

        def filter
          return if @params[:filter].blank?

          filter_params = @params[:filter].permit!.to_h
          allowed_keys = allowed_filters.map(&:to_s)

          allowed_filter_params = filter_params.slice(*allowed_keys)
          return if allowed_filter_params.blank?

          @scope = @scope.where(allowed_filter_params)
        end

        def sort
          sort_param = @params[:sort]
          direction = %w[asc desc].include?(@params[:direction]) ? @params[:direction] : 'asc'

          return unless allowed_sorts.include?(sort_param)

          @scope = @scope.order("#{sort_param} #{direction}")
        end

        def paginate
          per_page = [@params[:limit].to_i, MAX_PER_PAGE].min
          per_page = DEFAULT_PER_PAGE if per_page <= 0

          page = @params[:page].to_i
          page = 1 if page <= 0

          @pagy, @records = pagy(@scope, limit: per_page, page: page)
        end
      end
    end
  end
end
