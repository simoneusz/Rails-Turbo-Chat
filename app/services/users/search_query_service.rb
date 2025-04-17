# app/services/users/search_query_service.rb
module Users
  class SearchQueryService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      return success({ query: User.none, results: [] }) if search_query.blank?

      query = User.ransack(search_query)
      success({ query: query, results: query.result })
    end

    private

    def search_query
      raw_query = @params.dig(:q, :search)&.strip
      return {} if raw_query.blank?

      build_query(raw_query)
    end

    def build_query(raw_query)
      case raw_query[0]
      when '#'
        { username_cont: raw_query[1..] }
      when '@'
        { email_cont: raw_query[1..] }
      when '$'
        { first_name_or_last_name_cont: raw_query[1..] }
      else
        { username_or_email_or_first_name_or_last_name_cont_any: raw_query.split }
      end
    end
  end
end
