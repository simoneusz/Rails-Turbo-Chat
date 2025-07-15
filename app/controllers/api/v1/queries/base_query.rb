# frozen_string_literal: true

module Api
  module V1
    module Queries
      class BaseQuery
        include Pagy::Backend

        class_attribute :filters_definition, instance_predicate: false, default: {}
        class_attribute :sorts_definition, instance_predicate: false, default: {}

        DEFAULT_PER_PAGE = 20
        MAX_PER_PAGE = 100

        class << self
          # Define filters for the query
          #
          # @param field [Symbol] field name
          # @param only [Array<Symbol>] allowed filter actions
          # @return [Hash] filters definition
          def filter_by(field, only: %i[eq neq gt lt gte lte])
            self.filters_definition = filters_definition.merge(field.to_s => Array(only).map(&:to_s))
          end

          # Define sorts for the query
          #
          # @param field [Symbol] field name
          # @param only [Array<Symbol>] allowed sort actions
          # @return [Hash] sorts definition
          def sort_by(field, only: %i[asc desc])
            self.sorts_definition = sorts_definition.merge(field.to_s => Array(only).map(&:to_s))
          end
        end

        def initialize(scope, _params = {})
          @scope = scope
          @params = params
          return if @params.is_a?(ActionController::Parameters) || @params.is_a?(Hash)

          raise ArgumentError, 'Params must be ActionController::Parameters'
        end

        def call
          filter
          sort
          paginate
          [@pagy, @records]
        end

        private

        def filter
          return if @params[:filter].blank?

          filter_params = @params[:filter].permit!.to_h
          filter_conditions = []

          filter_params.each do |field, operations|
            filter_conditions.concat(handle_filter_params(field, operations))
          end

          filter_conditions.each do |condition|
            @scope = @scope.where(condition)
          end
        end

        def handle_filter_params(field, operations)
          allowed_ops = self.class.filters_definition[field.to_s]
          raise ArgumentError, "Filtering by '#{field}' is not allowed" if allowed_ops.blank?

          operations = { 'eq' => operations } unless operations.is_a?(Hash)

          operations.map do |op, value|
            op = op.to_s
            unless allowed_ops.include?(op)
              raise ArgumentError, "Filter operation '#{op}' is not allowed for field '#{field}'"
            end

            build_filter_condition(field, op, value)
          end
        end

        def build_filter_condition(field, operator, value)
          case operator
          when 'eq'  then { field => value }
          when 'neq' then ["#{field} != ?", value]
          when 'gt'  then ["#{field} > ?", value]
          when 'gte' then ["#{field} >= ?", value]
          when 'lt'  then ["#{field} < ?", value]
          when 'lte' then ["#{field} <= ?", value]
          else
            raise ArgumentError, "Unsupported filter operator: '#{operator}'"
          end
        end

        def sort
          sort_field = @params[:sort]
          direction  = @params[:direction].to_s.downcase.presence || 'asc'

          allowed = self.class.sorts_definition

          unless sort_field.present? && allowed.key?(sort_field) && allowed[sort_field].include?(direction)
            return @scope = @scope.order(created_at: :asc)
          end

          @scope = @scope.order("#{sort_field} #{direction}")
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
